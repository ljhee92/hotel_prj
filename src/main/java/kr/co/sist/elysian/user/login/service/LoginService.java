package kr.co.sist.elysian.user.login.service;

import org.apache.ibatis.exceptions.PersistenceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.sist.elysian.user.login.model.domain.UserDomain;
import kr.co.sist.elysian.user.login.model.vo.UserVO;
import kr.co.sist.elysian.user.login.repository.UserDAO;

@Service("userLoginService")
public class LoginService{
	
	@Autowired(required = false)
	private UserDAO uDAO;
	
	public UserDomain searchLogin( UserVO uVO ) {
		UserDomain udm = null;
		
		try {
			udm = uDAO.selectLogin( uVO );
		}catch(PersistenceException pe) {
			pe.printStackTrace();
		}//end catch
		
		return udm;
	} // searchLogin

	public void updateLoginDate(String userId ) {
		try {
			uDAO.updateLoginDate( userId );
		}catch(PersistenceException pe) {
			pe.printStackTrace();
		}//end catch
	}//updateLoginDate
	
	// 소셜 로그인 연동
	public int updateSocialId(UserVO userVO) {
		return uDAO.updateSocialId(userVO);
	} // updateSocialId

	// 소셜 로그인 접속 일자, 로그인 방법 업데이트
	public int updateSocialLoginDate(UserVO userVO) {
		return uDAO.updateSocialLoginDate(userVO);
	} // udpateSocialLoginDate
	
} // class