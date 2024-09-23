package kr.co.sist.elysian.user.login.service;

import com.google.api.client.auth.oauth2.TokenResponse;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import kr.co.sist.elysian.user.login.model.domain.UserDomain;
import kr.co.sist.elysian.user.login.model.vo.UserVO;
import kr.co.sist.elysian.user.login.repository.UserDAO;
import org.apache.ibatis.exceptions.PersistenceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.util.Map;

@Service
public class GoogleService {

    @Value("${google.client.id}")
    private String googleClientId;

    @Value("${google.client.pw}")
    private String googleClientPw;

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private LoginService loginService;

    // 구글 ID 토큰 검증 및 사용자 정보 가져오기
    public Map<String, Object> getGoogleUserInfo(String code) throws Exception {
        JsonFactory jsonFactory = JacksonFactory.getDefaultInstance();
        NetHttpTransport transport = new NetHttpTransport();
        TokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                transport, jsonFactory, googleClientId, googleClientPw,
                code, "http://localhost:8080/hotel_prj/user/googleLogin.do"
        ).execute();

        String idTokenString = tokenResponse.get("id_token").toString();
        GoogleIdToken idToken = GoogleIdToken.parse(jsonFactory, idTokenString);

        if(idToken != null) {
            GoogleIdToken.Payload payload = idToken.getPayload();
            return payload;
        } else {
            throw new Exception("유효하지 않은 ID Token입니다.");
        } // end else
    } // getGoogleUserInfo

    // 회원가입 정보를 DB에 저장
    public void registerUser(UserVO userVO) {
        try {
            userDAO.insertUserInfo(userVO);
        } catch (PersistenceException pe) {
            pe.printStackTrace();
            throw new RuntimeException("user 등록 실패", pe);
        } // catch
    } // registerUser

    // 구글 사용자 정보를 확인하고 세션을 설정
    public String handleGoogleUserInfo(Map<String, Object> userInfo, HttpSession session, String loginMethod) throws Exception {
        String socialId = userInfo.get("sub").toString();
        UserVO userVO = new UserVO();
        userVO.setSocialId(socialId);
        userVO.setLoginMethod(loginMethod);

        // DB에서 사용자 정보 확인
        UserDomain existUser = userDAO.selectSocialLogin(userVO);

        // 사용자 정보가 이미 존재하면 로그인 페이지로 리다이렉트
        if(existUser != null) {
            session.setAttribute("userID", existUser.getUserId());
            session.setAttribute("loginMethod", loginMethod);

            loginService.updateSocialLoginDate(userVO);

            return "/user/index.do";
        } else {
            // 사용자 정보가 없으면 회원 가입 페이지로 리다이렉트
            // 요청 파라미터로 사용자 정보 전달
            return "/user/socialJoin.do?socialId=" + socialId + "&loginMethod=GOOGLE";
        }
    } // handleGoogleUserInfo

} // class
