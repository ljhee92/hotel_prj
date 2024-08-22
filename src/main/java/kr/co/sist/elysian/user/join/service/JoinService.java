package kr.co.sist.elysian.user.join.service;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;

import kr.co.sist.elysian.user.join.repository.JoinDAO;
import kr.co.sist.elysian.user.mypage.model.domain.NationalDomain;
import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;
import org.apache.ibatis.exceptions.PersistenceException;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import kr.co.sist.elysian.user.login.model.domain.UserDomain;
import kr.co.sist.elysian.user.login.model.vo.UserVO;
import kr.co.sist.elysian.user.login.repository.UserDAO;
//import net.nurigo.java_sdk.api.Message;
//import net.nurigo.java_sdk.exceptions.CoolsmsException;

@Service
public class JoinService{
	
	@Autowired(required = false)
	private UserDAO uDAO;

	@Autowired(required = false)
	private JoinDAO joinDAO;
	
//	@Value("${sms.api.key}")
//    private String api_key;
//
//    @Value("${sms.api.secret.key}")
//    private String api_secret;

	final DefaultMessageService messageService;

	public JoinService(@Value("${api.key}") String key,  @Value("${api.secret.key}") String secretKey) {
		// 반드시 계정 내 등록된 유효한 API 키, API Secret Key를 입력해주셔야 합니다!
		this.messageService = NurigoApp.INSTANCE.initialize(key, secretKey, "https://api.coolsms.co.kr");
	} // JoinService

	//회원 아이디 중복 확인
	public UserDomain searchUser(UserVO uVO) {
		UserDomain udm = null;
		
		try {
			udm = uDAO.selectUser( uVO );
		} catch(PersistenceException pe ) {
			pe.printStackTrace();
		}//end catch
		
		return udm;
	}//searchUser
	
	//회원 이메일 중복 확인
	public UserDomain searchEmail(UserVO uVO) {
		UserDomain udm = null;
		
		try {
			udm = uDAO.selectEmail( uVO );
		} catch(PersistenceException pe ) {
			pe.printStackTrace();
		}//end catch
		
		return udm;
	}//searchEmail
	
	//회원 가입
	public int addUser(UserVO uVO) throws PersistenceException {
		
		PasswordEncoder pwEncoder = new BCryptPasswordEncoder();
		try {
            // 비밀번호 암호화
            String encodedPw = pwEncoder.encode(uVO.getUserPw());
            uVO.setUserPw(encodedPw);
            
            // nationCode 값 변경
            String nationCode = uVO.getNationCode();
            if (nationCode != null && !nationCode.isEmpty()) {
                uVO.setNationCode("10_" + nationCode);
            }
            
            // userName 값 변경
            String userName = uVO.getUserName();
            String eName1 = uVO.getEName1();
            String eName2 = uVO.getEName2();
            if (userName == null && userName.isEmpty()) {
            	uVO.setUserName(eName2 + " " + eName1);
            }

            // 회원 정보 저장
            int cnt = uDAO.insertUserInfo(uVO);
            return cnt;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("회원가입 중 오류가 발생했습니다.");
        }
		
	}//addUser

	/**
	 * 회원가입 휴대폰 번호 문자 인증 개선
	 * @param userPhone
	 * @param randomNumber
	 */
	private void certifiedPhoneNumber(String userPhone, int randomNumber) {
		Message message = new Message();

		// 발신번호 및 수신번호는 반드시 01012345678 형태로 입력되어야 합니다.
		message.setFrom("01039299258");
		message.setTo(userPhone);

		StringBuilder smsMessage = new StringBuilder();
		smsMessage.append("[Eysian호텔] SMS인증번호는 ").append(randomNumber).append("입니다. 정확히 입력해주세요.");

		message.setText(smsMessage.toString());

		SingleMessageSentResponse response = this.messageService.sendOne(new SingleMessageSendingRequest(message));
		System.out.println(response);
	} // certifiedPhoneNumber

	//회원가입 문자 인증
//	private void certifiedPhoneNumber(String userPhone, int randomNumber) {
//        Message coolsms = new Message(api_key, api_secret);
//
//        HashMap<String, String> params = new HashMap<String, String>();
//        System.out.println("Service : " + userPhone);
//        params.put("to", userPhone);
//        params.put("from", "01027345305");
//        params.put("type", "SMS");
//        params.put("text", "[Elysian] 인증번호는" + "[" + randomNumber + "]" + "입니다.");
//        params.put("app_version", "test app 1.2");
//
//        try {
//            JSONObject obj = (JSONObject) coolsms.send(params);
//            System.out.println("Response: " + new String(obj.toJSONString().getBytes(StandardCharsets.UTF_8), StandardCharsets.UTF_8));
//        } catch (CoolsmsException e) {
//            String errorMessage = new String(e.getMessage().getBytes(StandardCharsets.UTF_8), StandardCharsets.UTF_8);
//            System.out.println("CoolsmsException: " + errorMessage);
//            System.out.println("Error Code: " + e.getCode());
//        } catch (Exception e) {
//            String errorMessage = new String(e.getMessage().getBytes(StandardCharsets.UTF_8), StandardCharsets.UTF_8);
//            System.out.println("Exception: " + errorMessage);
//        }
//    }

	private int generateRandomNumber() {
        return (int)((Math.random() * (999999 - 100000 + 1)) + 100000); // 6자리 난수 생성
    } // generateRandomNumber

	public String sendSMS(String userPhone) {
        int randomNumber = generateRandomNumber();
        certifiedPhoneNumber(userPhone, randomNumber);
        return Integer.toString(randomNumber);
    } // sendSMS

	/**
	 * DAO에서 가져온 전체 국가 정보를 반환
	 * @return 전체 국가정보
	 */
	public List<NationalDomain> selectAllNationalInfo() {
		List<NationalDomain> allnationalInfo = null;
		try {
			allnationalInfo = joinDAO.selectAllNationalInfo();
		} catch(PersistenceException pe) {
			pe.printStackTrace();
		} // end catch
		return allnationalInfo;
	} // selectAllNationalInfo

} // class