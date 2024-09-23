package kr.co.sist.elysian.user.login.controller;

import kr.co.sist.elysian.user.login.service.GoogleService;
import kr.co.sist.elysian.user.login.service.KakaoService;
import kr.co.sist.elysian.user.login.service.LoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class SocialLoginController {

    @Autowired(required = false)
    private GoogleService googleService;

    @Autowired(required = false)
    private KakaoService kakaoService;

    @Autowired
    private LoginService loginService;

    @GetMapping("/googleLogin.do")
    public String googleLogin(@RequestParam("code") String code, HttpServletRequest request) throws Exception {
        Map<String, Object> userInfo = googleService.getGoogleUserInfo(code);
        HttpSession session = request.getSession();
        String redirectURL = googleService.handleGoogleUserInfo(userInfo, session, "GOOGLE");
        return "redirect:" + redirectURL;
    } // googleLogin

} // class