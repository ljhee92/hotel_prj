package kr.co.sist.elysian.user.login.repository;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.parameters.P;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Repository;

import kr.co.sist.elysian.common.dao.MyBatisDAO;
import kr.co.sist.elysian.user.login.model.domain.UserDomain;
import kr.co.sist.elysian.user.login.model.vo.UserVO;

@Repository
public class UserDAO {
    
    @Autowired(required = false)
    private MyBatisDAO mbDAO;

    // 일반 로그인
    public UserDomain selectLogin(UserVO uVO) throws PersistenceException {
        UserDomain udm = null;
        
        SqlSession ss = mbDAO.getMyBatisHandler(false);
        udm = ss.selectOne("kr.co.sist.elysian.member.login.searchLogin", uVO);
        mbDAO.closeHandler(ss);
        return udm;
    } // selectLogin

    // 소셜 로그인
    public UserDomain selectSocialLogin(UserVO userVO) throws PersistenceException {
        UserDomain userDomain = null;

        SqlSession sqlSession = mbDAO.getMyBatisHandler(false);
        userDomain = sqlSession.selectOne("kr.co.sist.elysian.member.login.searchSocialLogin", userVO);
        mbDAO.closeHandler(sqlSession);
        return userDomain;
    } // selectSocialLogin

    // 소셜 로그인 연동
    public int updateSocialId(UserVO userVO) throws PersistenceException {
        SqlSession sqlSession = mbDAO.getMyBatisHandler(false);
        int result = sqlSession.update("kr.co.sist.elysian.member.login.updateSocialLogin", userVO);
        mbDAO.closeHandler(sqlSession);
        return result;
    } // updateSocialId

    // 휴대폰번호 조회
    public UserDomain selectPhone(UserVO uVO) throws PersistenceException {
        SqlSession ss = mbDAO.getMyBatisHandler(false);

        // 전화번호에 하이픈을 추가하는 로직
        String phone = uVO.getUserPhone();
        if (phone != null && phone.length() == 10) { // 예: 0101234567
            phone = phone.replaceFirst("(\\d{3})(\\d{3})(\\d+)", "$1-$2-$3");
        } else if (phone != null && phone.length() == 11) { // 예: 01012345678
            phone = phone.replaceFirst("(\\d{3})(\\d{4})(\\d+)", "$1-$2-$3");
        } // else if

        uVO.setUserPhone(phone); // 하이픈이 포함된 전화번호를 설정
        System.out.println("Executing query with phone: " + uVO.getUserPhone()); // 추가된 출력문

        UserDomain udm = ss.selectOne("kr.co.sist.elysian.member.login.searchPhone", uVO);
        System.out.println("Query result: " + udm); // 추가된 출력문
        mbDAO.closeHandler(ss);
        return udm;
    } // selectPhone

    // 휴대폰번호 업데이트
    public int updateUserPw(UserVO uVO) throws PersistenceException {
    	System.out.println("DAO received userId: " + uVO.getUserId());
        System.out.println("DAO received newPassword: " + uVO.getUserPw());

        SqlSession ss = mbDAO.getMyBatisHandler(true);
        int result = ss.update("kr.co.sist.elysian.member.login.modifyPw", uVO);
        mbDAO.closeHandler(ss);
        return result;
    } // updateUserPw

    // 일반 로그인 최근 로그인 일자 업데이트
    public void updateLoginDate(String userId) throws PersistenceException {
        SqlSession ss = mbDAO.getMyBatisHandler(true);
        ss.update("kr.co.sist.elysian.member.login.updateLoginDate", userId);
        mbDAO.closeHandler(ss);
    } // updateLoginDate

    // 소셜 로그인 최근 로그인 일자, 로그인 방법 변경
    public int updateSocialLoginDate(UserVO userVO) throws PersistenceException {
        SqlSession ss = mbDAO.getMyBatisHandler(true);
        int result = ss.update("kr.co.sist.elysian.member.login.updateSocialLoginDate", userVO);
        mbDAO.closeHandler(ss);
        return result;
    } // updateSocialLoginDate
    
    // 회원가입시 아이디 중복확인
    public UserDomain selectUser(UserVO uVO) throws PersistenceException {
    	UserDomain udm = null;
        
        SqlSession ss = mbDAO.getMyBatisHandler(false);
        udm = ss.selectOne("kr.co.sist.elysian.member.join.searchUser", uVO);
        mbDAO.closeHandler(ss);
        return udm;
    } // selectUser
    
    // 회원가입시 이메일 중복확인
    public UserDomain selectEmail(UserVO uVO) throws PersistenceException {
    	UserDomain udm = null;
    	
    	SqlSession ss = mbDAO.getMyBatisHandler(false);
    	udm = ss.selectOne("kr.co.sist.elysian.member.join.searchEmail", uVO);
    	mbDAO.closeHandler(ss);
    	return udm;
    } // selectEmail
    
    // 회원가입
    public int insertUserInfo(UserVO uVO) throws PersistenceException {
    	SqlSession ss = mbDAO.getMyBatisHandler(true);
    	int cnt = ss.insert("kr.co.sist.elysian.member.join.insertUser", uVO);
    	mbDAO.closeHandler(ss);
    	return cnt;
    } // insertUserInfo

} // class