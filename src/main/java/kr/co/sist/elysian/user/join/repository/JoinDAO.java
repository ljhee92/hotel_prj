package kr.co.sist.elysian.user.join.repository;

import kr.co.sist.elysian.common.dao.MyBatisDAO;
import kr.co.sist.elysian.user.mypage.model.domain.NationalDomain;
import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class JoinDAO {

    @Autowired(required = false)
    private MyBatisDAO myBatisDAO;

    /**
     * MyBatis와 매핑하여 전체 국가코드, 국가명 조회
     * @return allnationalInfo
     * @throws PersistenceException
     */
    public List<NationalDomain> selectAllNationalInfo() throws PersistenceException {
        SqlSession ss = myBatisDAO.getMyBatisHandler(false);
        List<NationalDomain> allnationalInfo = ss.selectList("kr.co.sist.elysian.member.mypage.selectAllNationalInfo");
        myBatisDAO.closeHandler(ss);
        return allnationalInfo;
    } // selectAllNationlInfo

} // class