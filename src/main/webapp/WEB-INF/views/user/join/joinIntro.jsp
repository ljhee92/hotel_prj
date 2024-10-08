<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8" 
 info="" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
<meta name="format-detection" content="telephone=no">

<title>회원가입 - 약관동의 및 회원정보 입력 | 엘리시안호텔</title>

<!-- S head css -->
<jsp:include page="/WEB-INF/views/user/common/head_css.jsp"></jsp:include>
<link href="http://localhost:8080/hotel_prj/static/home/css/ko/pc/contents.css" rel="stylesheet" type="text/css">
<!-- E head css -->

<!-- S head script -->
<jsp:include page="/WEB-INF/views/user/common/head_script.jsp"></jsp:include>
<!-- E head script -->
</head>

<body>

<div class="skip"><a href="#container">본문 바로가기</a></div>
<div class="wrapper ">

	
<!--S header  -->
<jsp:include page="/WEB-INF/views/user/header.jsp"></jsp:include>
<!--E header  -->
	
<!--(페이지 URL)-->

<!-- <script type="text/javascript" src="/static/home/js/home.js"></script> -->

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script type="text/javascript">

    //체크박스 클릭시 실행
    // jQuery 문서가 준비되면 실행
    $(document).ready(function () {
        // 동의항목 전체 선택 처리
        var $frmChk00 = $('#frmChk00');
        $frmChk00.change(function () {
            var $this = $(this);
            var checked = $this.prop('checked'); // 체크 여부 확인 (true, false 반환)
            $this.closest(".agreeBox").find('input[name="mberAgreChk"]').prop('checked', checked); // 모든 'mberAgreChk' 체크박스를 동일한 상태로 설정
        }); //전체동의 change

        // 개별 동의항목 처리
        var $mberAgres = $('input[name="mberAgreChk"]');
        $mberAgres.change(function () {
            var $agreeBox = $(this).closest(".agreeBox");
            var $mberAllChk = $agreeBox.find(".frmAll input[type='checkbox']");

            var agresLength = $agreeBox.find($mberAgres).length;
            var checkedLength = $agreeBox.find('input[name="mberAgreChk"]:checked').length;

            var selectAll = (agresLength == checkedLength);
            $mberAllChk.prop('checked', selectAll); // 모든 항목이 선택된 경우 전체 선택 체크박스도 선택
        });//개별동의 change
        
        
      

        $("#nationCode").on("change", function () {
            updateUserNameField();
            validateUserName();
        });//change
        
        $("#eName1, #eName2").on("input", function () {
            updateUserNameField();
        });


        $("#userName").on("compositionend", function () {
            validateUserName();
        });//input
		
        // 초기 상태 설정
       // updateUserNameField();
        
        
        // 이메일 유형 선택 시 처리 ///////////////////////////////////
        $("#emailType").on("change", function () {
		    var value = $(this).val();
		    if (value == "") {
		        $("#email2").val("");
		        $("#email2").prop("readonly", false);
		    } else {
		        $("#email2").val(value);
		        $("#email2").prop("readonly", true);
		    }
		});//change


        // 아이디 영문, 숫자만 입력하도록 처리 //////////////////////////////
		$("#userId").on("keyup", function (e) {
		    if (!(e.keyCode >= 37 && e.keyCode <= 40)) {
		        var inputVal = $(this).val();
		        $(this).val(inputVal.replace(/[^a-z0-9]/gi, ''));
		    }
		});//keyup

        
        //문자인증 및 인증번호 확인 기능 /////////////////////////////////////
		$("#phoneChk").click(function() {
		    gfncNameCert();
		});//click

		$("#phoneChk2").click(function() {
		    verifyPopup();
		});//click
        
		
		//전화번호 입력 시 포맷팅 ///////////////////////////////////////////
		$('#userPhone').on('focus', function() {
		    $(this).closest('.verifyPhoneFrm').removeClass('error');
		});//focus
		
		$('#userPhoneVerify').on('focus', function() {
		    $(this).closest('.verifyNumFrm').removeClass('error');
		});//focus

		$('#userPhone').on('input', function() {
		    var input = $(this).val().replace(/[^0-9]/g, ''); // 숫자 이외의 문자 제거
		    var formatted = '';

		    if (input.length > 3) {
		        formatted += input.substr(0, 3) + '-';
		        input = input.substr(3);
		    }//end if

		    if (input.length > 4) {
		        formatted += input.substr(0, 4) + '-';
		        input = input.substr(4);
		    }//end if

		    formatted += input;
		    $(this).val(formatted);

		    if (formatted.length >= 13) {
		        $(this).val(formatted.substr(0, 13)); // 최대 길이 제한
		    }//end if
		});//input
		
		//생년월일////////////////////////////////////
		$("#userBirth").on("input", function() {
	        formatBirthDate(this);
	    }).on("blur", function() {
	        validateBirthDate(this);
	    });
        
    });//ready
    
    var natFlag=false;
    // 국가 코드 변경 시 처리 /////////////////////////////////////////////
    function updateUserNameField() {
    	
        var selectedCountry = $("#nationCode").val();
        if (selectedCountry !== "KR") {
            var eName1 = $("#eName1").val().toUpperCase();
            var eName2 = $("#eName2").val().toUpperCase();
            $("#userName").val(eName2 + " " + eName1);
            $("#userName").attr("readonly", true);
            natFlag = false;
        } else {
        	natFlag = true;
            $("#userName").attr("readonly", false);
        }
    }//updateUserNameField

    function validateUserName() {
        var selectedCountry = $("#nationCode").val();
        if (selectedCountry === "KR") {
            var userName = $("#userName").val();
            // 한글만 입력 가능하고 최대 10글자로 제한
            var validUserName = userName.replace(/[^가-힣]/g, '').substring(0, 10);
            $("#userName").val(validUserName);

            if (validUserName.length === 0 || validUserName.length > 10) {
                $("#userNameField").addClass('error');
                $("#userNameField .alertMessage").text("이름은 한글만 입력 가능하며 10자 이하로 입력해 주세요.").removeClass('hidden');
            } else {
                $("#userNameField").removeClass('error');
                $("#userNameField .alertMessage").addClass('hidden');
            }
        } else {
            $("#userNameField").removeClass('error');
            $("#userNameField .alertMessage").addClass('hidden');
        }//end if
    }//validateUserName

    var registFlag = false;

    //회원가입 요청
    function fncRegist() {
        var eName1 = jQuery.trim(jQuery("#eName1").val());  // 영문 성
        var eName2 = jQuery.trim(jQuery("#eName2").val());  // 영문 이름
        var userName = jQuery.trim(jQuery("#userName").val());  // 한글 이름
        var userId = jQuery.trim(jQuery("#userId").val());  // 아이디 입력
        var userPw = jQuery.trim(jQuery("#userPw").val());  // 비밀번호 입력
        var userPwRe = jQuery.trim(jQuery("#userPwRe").val());  // 비밀번호 재입력 확인
        var genderCode = jQuery.trim(jQuery("#genderCode").val());  // 성별
        var postcode = jQuery.trim(jQuery("#postcode").val());  // 우편번호
        var userBirth = jQuery.trim(jQuery("#userBirth").val());  // 생일
        var address = jQuery.trim(jQuery("#address").val());  // 주소
        var detailAddress = jQuery.trim(jQuery("#detailAddress").val()); // 상세주소
        var email1 = jQuery.trim(jQuery("#email1").val());  // 이메일1 입력
        var email2 = jQuery.trim(jQuery("#email2").val());  // 이메일2 입력
        var email = email1 + "@" + email2;  // 이메일 조합
        var nationCode = jQuery("#nationCode option:selected").val();
        var addressType = $('input[name="addressType"]:checked').val();
        var loginMethod = jQuery.trim(jQuery("#loginMethod").val()); //로그인 방법 일반으로 고정
        jQuery("#email").val(email);  // 이메일 조합형 hidden 세팅
        jQuery("#nationCodeH").val(nationCode);  // 국가코드 설정
		
        
     	// 약관 동의 체크
        if (!$('#frmChk01').is(':checked')) {
            alert("이용 약관에 동의해 주세요.");
            return;
        }

        // 약관동의 처리
        var chkArray = [];
        $('input[name="mberAgreChk"]').each(function() {
            if (this.id !== 'frmChk01') {  // frmChk01은 별도로 체크하므로 제외
                if ($(this).is(":checked")) {
                    chkArray.push(this.value + "Y");
                } else {
                    chkArray.push(this.value + "N");
                }
            }
        });
        $('#mberAgreArrH').val(chkArray);
        
        /*
        사용자 입력정보 VALIDATION 체크
        해당 열 input, select 박스가 하나라도 미기재 된 경우 validation false
        최초 미입력 된 element로 focus 이동됨
        */
        var frstIdx = "";
        jQuery(".intList li").each(function () {
            var $this = jQuery(this);
            var validYn = true;
            $this.find("input[type='text'],input[type='password']").each(function (idx) {
                var value = jQuery(this).val();
                var id = jQuery(this).attr("id");
                if (value == "" && id != "emailType" && id != "recomdrId" && id != "recomdrId2" && id != "cmpgnCode") {
                    validYn = false;
                    if (frstIdx == "") {
                        frstIdx = jQuery(this);
                    }
                }
                // 한글 이름 유효성 검사 추가
                if (id == "userName" && natFlag) {
                    var pattern_kor = /^[가-힣]+$/; // 한글만
                    if (value.length > 0) {
                        if (!pattern_kor.test(value)) {
                            validYn = false;
                            if (frstIdx == "") {
                                frstIdx = jQuery(this);
                            }
                            jQuery(this).closest('li').addClass('error');
                            jQuery(this).siblings('.alertMessage').text("이름은 한글만 입력 가능합니다.").show();
                        } else {
                            jQuery(this).closest('li').removeClass('error');
                            jQuery(this).siblings('.alertMessage').hide();
                        }
                    } else {
                        validYn = false;
                        if (frstIdx == "") {
                            frstIdx = jQuery(this);
                        }
                        jQuery(this).closest('li').addClass('error');
                        jQuery(this).siblings('.alertMessage').text("이름은 필수 입력값으로, 한글로 입력해주세요.").show();
                    }
                }
            });

            if (!validYn) {
                $this.addClass("error");
                $this.find(".alertMessage").show();
            } else {
                $this.removeClass("error");
                $this.find(".alertMessage").hide();
            }
        });
        if (frstIdx != "") {
            frstIdx.focus();
            return false;
        }

        // 회원가입 약관 동의
        if ($("input:checkbox[id='frmChk01']").is(":checked") == false) {
            alert("이용 약관에 동의해 주세요.");
            jQuery("#frmChk01").focus();
            return;
        }

        // 개인정보 수집ㆍ이용 동의
        if ($("input:checkbox[id='frmChk01']").is(":checked") == false) {
            alert("개인정보 수집ㆍ이용에 동의해 주세요.");
            jQuery("#frmChk01").focus();
            return;
        }

        // 영문(성) 체크
        if (eName1.length > 0) {
            var pattern_eng = /[a-zA-Z]/;  // 문자
            if (!pattern_eng.test(eName1)) {
                alert("영문(성)은 영문만 입력 가능합니다.");
                jQuery("#eName1").focus();
                return;
            }
        } else {
            alert("영문(성)은 필수 입력값 입니다.");
            jQuery("#eName1").focus();
            return;
        }

        // 영문(이름) 체크
        if (eName2.length > 0) {
            var pattern_eng = /[a-zA-Z]/;  // 문자
            if (!pattern_eng.test(eName2)) {
                alert("영문(이름)은 영문만 입력 가능합니다.");
                jQuery("#eName2").focus();
                return;
            }
        } else {
            alert("영문(이름)은 필수 입력값 입니다.");
            jQuery("#eName2").focus();
            return;
        }
        
     	// 한글이름 형식 검증
        if (userName.length === 0) {  // 이름이 비어 있는 경우 경고 메시지 표시
            alert('이름은 필수 입력값 입니다.');
            jQuery("#userName").focus();
            return;
        }

        // 비밀번호1 형식 검증
        if (!gfncPatternCheck(userPw)) {
            alert('비밀번호는 영문/숫자/특수문자 조합 8~12자리까지 입력 가능합니다.');
            jQuery("#userPw").focus();
            return;
        }
        
        // 비밀번호2 형식 검증
        if (!gfncPatternCheck(userPwRe)) {
            alert('비밀번호는 영문/숫자/특수문자 조합 8~12자리까지 입력 가능합니다.');
            jQuery("#userPwRe").focus();
            return;
        }

        // 비밀번호 확인 일치 검증
        if (userPw != userPwRe) {
            alert('비밀번호 확인이 일치하지 않습니다.');
            jQuery("#userPwRe").focus();
            return;
        }
        
     	// 전화번호 유효성 검사 추가
        var userPhone = jQuery.trim(jQuery("#userPhone").val());
        if (userPhone.length < 1) {
            alert("전화번호를 입력해주세요.");
            jQuery("#userPhone").focus();
            return;
        }
        var phonePattern = /^\d{3}-\d{4}-\d{4}$/;
        if (!phonePattern.test(userPhone)) {
            alert("올바른 전화번호를 입력해 주세요.");
            jQuery("#userPhone").focus();
            return;
        }

        // 우편번호 체크
        if (postcode.length > 0) {

        } else {
            alert("주소입력은 필수 입니다.");
            jQuery("#postcode").focus();
            return;
        }

        // 주소 체크
        if (address.length > 0) {

        } else {
            alert("주소입력은 필수 입니다.");
            jQuery("#address").focus();
            return;
        }

        // 상세주소 체크
        if (detailAddress.length > 0) {

        } else {
            alert("상세주소입력은 필수 입니다.");
            jQuery("#detailAddress").focus();
            return;
        }
        
     	// 생년월일 유효성 검사
        if (!isValidDate(userBirth)) {
            alert("유효하지 않은 생년월일입니다");
            jQuery("#userBirth").focus();
            return;
        }

        // 이메일 형식 검증
        if (!gfncEmailCheck(email)) {
            alert("이메일 형식을 다시 확인해 주세요.");
            jQuery("#email1").focus();
            return;
        }
        
     	// 인증번호 확인 버튼이 비활성화 상태인지 확인
        if (!$("#phoneChk2").prop("disabled")) {
            alert("인증번호 확인을 완료해 주세요");
            return;
        }

        //이메일,아이디 중복체크 여부
        var emailDupChkYn = jQuery("#emailDupChkYn").val();
        var idDupChkYn = jQuery("#idDupChkYn").val();
        
        if (idDupChkYn != 'Y') {
            alert("아이디 중복체크가 필요합니다");
            return;
        }
        
        if (emailDupChkYn != 'Y') {
            alert("이메일 중복체크가 필요합니다");
            return;
        }
        

        if (!registFlag) {

            registFlag = true;

            //회원가입 요청
            var formData = jQuery("#formJoin").serialize();
            jQuery.ajax({
                type: "POST",
                url: "/hotel_prj/user/joinInsert.do",
                cache: false,
                data: formData,
                dataType: "json",
                global: false,
                success: function (data) {
                    if (data.statusR == 200) {
                        //전달받은 멤버십번호가 존재할 경우 완료페이지
                        goJoinComplete();
                    } else {
                        registFlag = false;
                        //alert("관리자에게 문의하세요.");
                        //alert(data.messageR + "(" + data.statusR + " : " + data.codeR + ")");
                        alert(data.statusR + " : " + data.codeR + " : " + data.messageR);
                        return;
                    }
                },
                error: function () {
                    registFlag = false;
                    alert("관리자에게 문의하세요");
                    return;
                }
            });
        }
    }

    //일반 회원가입 완료페이지
    function goJoinComplete() {
        jQuery("#formJoin").attr("action", "joinComplete.do");
        jQuery("#formJoin").attr("method", "post");
        jQuery("#formJoin").submit();
    }
    
  	//한글 이름
    function fncUserNameChk() {

        //전화번호 입력여부 확인alert
        var userName = jQuery.trim(jQuery("#userName").val());
        if (userName.length < 1) {
            alert("입력된 이름이 없습니다.");
            return false;
        }
  	}
        
    //아이디 중복체크
    function fncIdDupChk() {

        //아이디 입력여부 확인alert
        var id = jQuery.trim(jQuery("#userId").val());
        if (id.length < 1) {
            alert("입력된 아이디가 없습니다.");
            return false;
        }

        var userId = jQuery.trim(jQuery("#userId").val());// 아이디 입력
        //사용자아이디 소문자변환
        jQuery("#userId").val(userId.toLowerCase());

        //아이디 유효성 체크
        function chkId(userId) {
            var id = userId;
            var num = id.search(/[0-9]/g);
            var eng = id.search(/[a-z]/ig);
            var spe = id.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);
            if (id.length < 8 || id.length > 12) {
                alert("아이디는 8자리 ~ 12자리 이내로 입력해주세요.");
                return false;
            } else if (id.search(/\s/) != -1) {
                alert("아이디는 공백 없이 입력해주세요.");
                return false;
            } else if (num < 0 || eng < 0) {
                alert("아이디는 영문,숫자를 혼합하여 입력해주세요.");
                return false;
            } else if (spe > 0) {
                alert("아이디는 특수문자 입력이 불가합니다.");
                return false;
            } else {
                return true;
            }
        }

        //아이디 유효성 체크
        if (!chkId(userId)) {
            jQuery("#userId").focus();
            return;
        }

        var formData = jQuery("#formJoin").serialize();
        jQuery.ajax({
            type: "POST",
            url: "/hotel_prj/user/chk_id.do",
            cache: false,
            data: formData,
            dataType: "json",
            global: false,
            success: function (data) {

                if (data.statusR == 200 && data.codeR == 'S00000') {
                    alert("사용가능한 ID입니다.");
                    //아이디중복체크 확인여부
                    jQuery("#idDupChkYn").val("Y");
                } else if (data.statusR == 400) {
                    alert("이미 사용중인 ID입니다.");
                } else {
                    alert(data.statusR + ": 관리자에게 문의하세요.");
                }
            },
            error: function () {
                alert("관리자에게 문의하세요.");
            }
        });
    }
    
 	// 생년월일 입력 형식 처리
    function formatBirthDate(input) {
        // 숫자와 '-'만 남기기
        var value = input.value.replace(/[^0-9]/g, '');

        // 년도 처리
        if (value.length > 4) {
            value = value.slice(0, 4) + '-' + value.slice(4);
        }

        // 월 처리
        if (value.length > 7) {
            value = value.slice(0, 7) + '-' + value.slice(7);
        }

        // 최대 길이 제한
        if (value.length > 10) {
            value = value.slice(0, 10);
        }

        input.value = value;
    }

    // 생년월일 유효성 검사 함수
    function isValidDate(dateString) {
        // 날짜 형식 확인 (YYYY-MM-DD)
        var regex = /^\d{4}-\d{2}-\d{2}$/;
        if (!regex.test(dateString)) return false;

        var parts = dateString.split("-");
        var year = parseInt(parts[0], 10);
        var month = parseInt(parts[1], 10);
        var day = parseInt(parts[2], 10);

        // 년도 범위 확인
        var currentYear = new Date().getFullYear();
        if (year < 1900 || year > currentYear) return false;

        // 월 범위 확인
        if (month < 1 || month > 12) return false;

        // 일 범위 확인
        var monthDays = [31, (year % 4 === 0 && year % 100 !== 0 || year % 400 === 0) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        if (day < 1 || day > monthDays[month - 1]) return false;

        return true;
    }

    // 생년월일 유효성 검사 후 경고 메시지 표시
    function validateBirthDate(input) {
        var value = input.value;
        var alertMessage = input.nextElementSibling; // alertMessage 요소

        if (!isValidDate(value)) {
            alertMessage.style.display = 'block';
            alertMessage.innerText = "유효하지 않은 생년월일입니다.";
        } else {
            alertMessage.style.display = 'none';
        }
    }



 	// 이메일 중복체크
    function fncEmlDupChk() {
        // 이메일 데이터 조합
        var email1 = jQuery.trim(jQuery("#email1").val()); // 이메일1 입력
        var email2 = jQuery.trim(jQuery("#email2").val()); // 이메일2 입력
        var email = email1 + "@" + email2; // 이메일 조합
        jQuery("#email").val(email);

        // 이메일 입력여부 확인
        if (email1.length < 1 || email2.length < 1) {
            alert("입력된 이메일이 없습니다.");
            return false;
        }

        var formData = jQuery("#formJoin").serialize();
        jQuery.ajax({
            type: "POST",
            url: "/hotel_prj/user/chk_email.do",
            cache: false,
            data: { email: email }, // 이메일 파라미터를 명시적으로 포함
            dataType: "json",
            global: false,
            success: function (data) {
                if (data.statusR == 200 && data.codeR == 'S00000') {
                    alert("사용가능한 email입니다.");
                    // 이메일 중복체크 확인여부
                    jQuery("#emailDupChkYn").val("Y");
                } else if (data.statusR == 400) {
                    alert("이미 사용중인 email입니다.");
                }
            },
            error: function () {
                alert("관리자에게 문의하세요.");
            }
        });
    }

    /**
     * 이메일 형식 체크
     * @param str    검증 문자열
     * @returns {Boolean}
     */
    function gfncEmailCheck(str) {
        var regExp = /[0-9a-zA-Z][_0-9a-zA-Z-]*@[_0-9a-zA-Z-]+(\.[_0-9a-zA-Z-]+){1,2}$/;

        //입력을 안했으면
        if (str.lenght == 0) {
            return false;
        }

        //이메일 형식에 맞지않으면
        if (str.match(regExp)) {
            return true;
        }

        return false;
    }

    /*---------------주소검색 시작--------------------------------- */
    var themeObj = {
        bgColor: "#162525", //바탕 배경색
        searchBgColor: "#162525", //검색창 배경색
        contentBgColor: "#162525", //본문 배경색(검색결과,결과없음,첫화면,검색서제스트)
        pageBgColor: "#162525", //페이지 배경색
        textColor: "#FFFFFF", //기본 글자색
        queryTextColor: "#FFFFFF", //검색창 글자색
        //postcodeTextColor: "", //우편번호 글자색
        //emphTextColor: "", //강조 글자색
        outlineColor: "#444444" //테두리
    };

    //신주소 입력
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function (data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.
                // 예제를 참고하여 다양한 활용법을 확인해 보세요.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }


                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if (data.userSelectedType === 'R') {
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if (data.buildingName !== '' && data.apartment === 'Y') {
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if (extraAddr !== '') {
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                    //document.getElementById("sample2_extraAddress").value = extraAddr;

                } else {
                    //document.getElementById("sample2_extraAddress").value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('postcode').value = data.zonecode;
                document.getElementById("address").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("detailAddress").focus();
            }
        }).open();
    }

    // 우편번호 찾기 화면을 넣을 element
    var element_layer = document.getElementById('layer');

    function closeDaumPostcode() {
        // iframe을 넣은 element를 안보이게 한다.
        element_layer.style.display = 'none';
    }


    // 브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
    // resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
    // 직접 element_layer의 top,left값을 수정해 주시면 됩니다.
    function initLayerPosition() {
        var width = 300; //우편번호서비스가 들어갈 element의 width
        var height = 400; //우편번호서비스가 들어갈 element의 height
        var borderWidth = 5; //샘플에서 사용하는 border의 두께

        // 위에서 선언한 값들을 실제 element에 넣는다.
        element_layer.style.width = width + 'px';
        element_layer.style.height = height + 'px';
        element_layer.style.border = borderWidth + 'px solid';
        // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
        element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width) / 2 - borderWidth) + 'px';
        element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height) / 2 - borderWidth) + 'px';
    }

    /*---------------주소검색 종료--------------------------------- */

    //회원가입 취소버튼 클릭시
    function fncCancel() {
        var result = confirm("회원가입을 취소하시겠습니까?");
        if (result) {

        	jQuery("#formJoin").attr("action", "/hotel_prj/user/index.do");
            jQuery("#formJoin").attr("method", "post");
            jQuery("#formJoin").submit();
        } else {
            return;
        }

    }

    //아이디수정시 중복체크여부 초기화(N)
    function idDupInit() {
        jQuery("#idDupChkYn").val("N");
    }

    //이메일수정시 중복체크여부 초기화(N)
    function emailDupInit() {
        jQuery("#emailDupChkYn").val("N");
    }
 	
    
    //문자인증 관련
	var code2; //인증번호 저장 변수
    
	function isValidPhoneFormat(phone) {
        var phonePattern = /^\d{3}-\d{4}-\d{4}$/;
        return phonePattern.test(phone);
    }

    function removeHyphens(phone) {
        return phone.replace(/-/g, '');
    }

    function gfncNameCert() {
        var phone = $("#userPhone").val();

        if (phone.trim() === "") {
            alert("전화번호를 입력해주세요.");
            return;
        }

        if (isValidPhoneFormat(phone)) {
            var sanitizedPhone = removeHyphens(phone);
            sendSMSToServer(sanitizedPhone);
        } else {
            alert("올바른 전화번호를 입력해 주세요.");
            $('#userPhone').closest('.verifyPhoneFrm').addClass('error');
        }
    }

    function sendSMSToServer(phone) {
        $.ajax({
            type: "POST",
            url: "/hotel_prj/user/sendSMS.do",
            data: { userPhone: phone },
            success: function(response) {
                if (response.status === "success") {
                    alert("인증번호 발송이 완료되었습니다.\n휴대폰에서 인증번호 확인을 해주십시오.");
                    $("#userPhoneVerify").attr("disabled", false);
                    code2 = response.code; // 서버에서 받은 인증번호를 저장
                } else {
                    alert("문자 전송에 실패했습니다. 관리자에게 문의하세요.");
                }
            },
            error: function() {
                alert("문자 전송에 실패했습니다. 관리자에게 문의하세요.");
            }
        });
    }

    function verifyPopup() {
        if ($("#userPhoneVerify").val() == code2) {
            alert("인증번호가 일치합니다.");
            $("#userPhoneVerify").attr("disabled", true);
            $("#phoneChk").attr("disabled", true);
            $("#phoneChk2").attr("disabled", true); // phoneChk2 버튼 비활성화
            $("#userPhone").attr("readonly", true); // userPhone 필드 읽기 전용
        } else {
            alert("인증번호가 일치하지 않습니다. 확인해주시기 바랍니다.");
            $('#userPhoneVerify').closest('.verifyNumFrm').addClass('error');
        }
    }

</script>

<form id="formJoin" name="formJoin">
	<!-- 이메일 조합용 -->
	<input type="hidden" id="email" name="email" value="">
	<!-- 로그인 방법 설정용 -->
	<input type="hidden" id="loginMethod" name="loginMethod" value="일반">

	<!-- 문자인증 전송 실행여부 -->
	<input type="hidden" id="phoneChkYn" name="phoneChkYn" value="N"/>
	<!-- 문자인증 인증번호 확인여부 -->
	<input type="hidden" id="phoneChk2Yn" name="phoneChk2Yn" value="N"/>

    <!--아이디 중복체크 실행여부  -->
    <input type="hidden" id="idDupChkYn" name="idDupChkYn" value="N"/>
    <!--이메일 중복체크 실행여부  -->
    <input type="hidden" id="emailDupChkYn" name="emailDupChkYn" value="N"/>

    <div id="container" class="container join">
        <!-- 컨텐츠 S -->
        <h1 class="hidden">회원가입</h1>
        <div class="topArea">
            <div class="topInner">
                <h2 class="titDep1">Join Now</h2>
                <div class="stepWrap">
                    <ol>
                        <li class="prev"><em>본인 인증</em></li>
                        <li class="on"><span class="hidden">현재단계</span><em>약관동의 및 회원정보 입력</em></li>
                    </ol>
                </div>
            </div>
        </div>
        <div class="inner">
            <h2 class="titDep2">회원가입 약관</h2>
            <!-- 20200720 수정 -->
            <p class="pageGuide tleft">엘리시안은 체계적인 회원 정보 관리를 위하여 아래와 같이 개인정보를 수집·이용 및 제공하고자 합니다.<br>내용을 자세히 읽으신 후 동의
                여부를 결정하여 주시기 바랍니다.</p>
            <!-- //20200720 수정 -->
            <div class="agreeBox">
                <div class="nonToggle">
                        <span class="frm frmAll">
                            <input type="checkbox" id="frmChk00"><label for="frmChk00">전체동의</label>
                        </span>
                    <ul class="listInfo">
                        <li>아래 동의 항목을 개별 확인 후 동의하실 수 있습니다.</li>
                    </ul>
                    
                </div>
                <!-- 20200720 수정 -->
                <ul class="toggleList agreeCont">
                    <!-- 20200709 수정 : (.toggleList → .toggleList.agreeCont) 약관통합class(추가) -->
                    <li>
							<span class="frm type02">
								<input type="checkbox" id="frmChk01" name="mberAgreChk" value="A0001"><label
                                    for="frmChk01">[필수] 개인정보수집 및 이용에 대한 동의</label>
							</span>
                        <button type="button" class="btnToggle"><span class="hidden">상세내용 보기</span></button>
                        <div class="toggleCont">
                            <div class="toggleInner">
                                <p class="notiTxt">엘리시안은 회원가입과 관련하여 아래와 같은 개인정보를 수집 및 이용하고 있습니다.<br>개인정보 처리에 대한
                                    상세한 사항은 엘리시안 홈페이지의 '개인정보처리방침'을 참조하십시오.</p>
                                <p class="notiTxt">본 개인정보 수집 및 이용 동의서의 내용과 상충되는 부분은 본 동의서의 내용이 우선합니다.</p>
                                <table class="tblH">
                                    <colgroup>
                                        <col style="width:33%">
                                        <col style="width:34%">
                                        <col style="width:auto">
                                    </colgroup>
                                    <caption>개인정보수집 및 이용에 대한 동의 목록</caption>
                                    <thead>
                                    <tr>
                                        <th scope="col">수집 항목</th>
                                        <th scope="col">수집 목적</th>
                                        <th scope="col">보유 기간</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <th scope="row" class="tcenter">회원 ID, 비밀번호, 이름, 생년월일, 국적, 성별, 휴대폰번호, 주소</th>
                                        <td>서비스 이용자 식별 및 본인, 14세 이상 여부 확인</td>
                                        <td class="f18" rowspan="3">회원탈퇴 시 까지</td>
                                    </tr>
                                    <tr>
                                        <th scope="row" class="tcenter">휴대폰번호, 이메일주소</th>
                                        <td>계약 이행을 위한 연락 및 민원업무 처리 등의 의사소통</td>
                                    </tr>
                                    </tbody>
                                </table>
                                <p class="txtGuide">위의 개인정보 수집 및 이용에 대한 동의를 거부할 권리가 있으나 동의를 거부하실 경우 회원가입, 엘리시안 호텔 서비스 이용이
                                    불가합니다.</p>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>

            <h2 class="titDep2">필수정보 입력</h2>
            <div class="frmBox">
                <div class="userInfo">
                    <!-- [국문] 휴대폰인증 후, Default -->
                    <dl>
                        <dt>회원정보</dt>
                    </dl>
                </div>
                <div class="frmInfo">
                    <ul class="intList">
                        <li class="error"> <!-- 미입력 일 경우 error 클래스 추가 alertMessage 노출 -->
                            <div class="intWrap"><span class="tit"><label for="eName">ENGLISH NAME</label><span
                                    class="essential">필수</span></span></div>
                            <div class="intInner duobuleInp">
                                <span class="intArea"><input type="text" id="eName1" name="eName1" maxlength="35"
															 placeholder='Family Name (성)' style="width:515px;"
                                                             aria-required="true"
                                                             onkeyup="this.value=this.value.replace(/[^a-z]/gi, '').toUpperCase();"><span
                                        class="alertMessage">영문만 입력 가능하며, 띄어쓰기도 문자로 인식됩니다.</span></span>
                                <span class="intArea"><input type="text" id="eName2" name="eName2" maxlength="35"
															 placeholder='First Name (이름)' style="width:515px"
                                                             aria-required="true"
                                                             onkeyup="this.value=this.value.replace(/[^a-z]/gi, '').toUpperCase();"></span>
                            </div>
                        </li>
                        
                        
						<!-- 한글이름 -->
						<li id="userNameField"> <!-- 미입력 일 경우 error 클래스 추가 alertMessage 노출 -->
						    <div class="intWrap">
						        <span class="tit"><label for="userName">KOREAN NAME (or English full name)</label><span class="essential">필수</span></span>
						    </div>
						    <div class="intInner">
						        <span class="intArea">
						            <input type="text" id="userName" name="userName" maxlength="35" placeholder="이름" 
						            style="width:515px;" aria-required="true"/>
						            <span class="alertMessage hidden">이름을 입력해 주세요.</span>
						        </span>
						    </div>
						</li>

						
						<!-- 휴대폰 본인 인증 -->
						<li>
						    <div class="intWrap">
						        <span class="tit"><label for="userPhone">PHONE NUMBER</label><span class="essential">필수</span></span>
						    </div>
						    <div class="intInner">
						        <span class="intArea">
						            <input type="text" id="userPhone" name="userPhone" placeholder="(ex) 01012345678" style="width:200px" aria-required="true">
						            <span class="alertMessage" style="display: none;">전화번호를 입력해주세요.</span>
						        </span>
						        <button type="button" class="btnSC btnM" id="phoneChk">문자인증</button>
						    </div>
						</li>
						
						<li>
						    <div class="intWrap">
						        <span class="tit"><label for="userPhoneVerify">Verification</label><span class="essential">필수</span></span>
						    </div>
						    <div class="intInner">
						        <span class="intArea">
						            <input type="text" id="userPhoneVerify" name="userPhoneVerify" placeholder="숫자 6자리" style="width:200px" aria-required="true">
						            <span class="alertMessage" style="display: none;">인증번호를 입력해주세요.</span>
						        </span>
						        <button type="button" class="btnSC btnM active" id="phoneChk2">인증번호 확인</button>
						    </div>
						</li>
						
						<li>
						    <div class="intWrap">
						        <span class="tit"><label for="userId">ID</label><span class="essential">필수</span></span>
						    </div>
						    <div class="intInner">
						        <span class="intArea">
						            <input type="text" id="userId" name="userId" onkeyup="javascript:idDupInit();" placeholder="영문/숫자 조합으로 8 ~ 12자리로만 가능합니다." style="width:515px" aria-required="true">
						            <span class="alertMessage" style="display: none;">아이디를 입력해주세요.</span>
						        </span>
						        <button type="button" class="btnSC btnM" onclick="fncIdDupChk(); return false;">ID 중복 확인</button>
						    </div>
						</li>

                        <li>
                            <div class="intWrap"><span class="tit"><label for="">PASSWORD</label><span
                                    class="essential">필수</span></span></div>
                            <div class="intInner">
                                <span class="intArea"><input type="password" id="userPw" name="userPw"
                                                             placeholder="영문/숫자/특수문자를 사용하며, 8 ~ 12자리로만 가능합니다."
                                                             style="width:515px" aria-required="true"><span
                                        class="alertMessage">비밀번호를 입력해주세요.</span></span>
                            </div>
                            <p class="txtGuide">비밀번호 내 ID가 포함되거나, 연속되는 문자 또는 숫자는 3자리 이상 사용할 수 없습니다.</p>
                            <p class="txtGuide">특수문자(!@#$%^&+=)중 하나를 선택하시면 됩니다.</p><!-- 2021-02-03 추가 -->
                        </li>
                        <li class="intList-repwd" style="margin-top: -171px !important;">
                            <div class="intWrap"><span class="tit"><label for="">CONFIRM PASSWORD</label><span
                                    class="essential">필수</span></span></div>
                            <div class="intInner">
                                <span class="intArea"><input type="password" id="userPwRe" name="userPwRe"
                                                             placeholder="영문/숫자/특수문자를 사용하며, 8 ~ 12자리로만 가능합니다."
                                                             style="width:515px" aria-required="true"><span
                                        class="alertMessage">동일한 비밀번호를 입력해주세요.</span></span>
                            </div>
                        </li>
                        <li><!-- 성별 추가 -->
                            <div class="intWrap"><span class="tit"><label for="genderCode">GENDER</label><span
                                    class="essential">필수</span></span></div>
                            <div class="intInner">
                                <div class="gender selectWrap" style="width:200px !important">
                                    <select id="genderCode" name="genderCode">
                                        
                                            <option value="M"
                                                     >남</option>
                                        
                                            <option value="F"
                                                     >여</option>
                                    </select>
                                </div>
                                <span class="alertMessage">성별을 선택해주세요.</span>
                            </div>
                        </li>
                        
                        
                        <li><!-- 20200528 수정 : 국적정보(추가) -->
                            <div class="intWrap"><span class="tit"><label for="nationCode">NATIONALITY</label><span
                                    class="essential">필수</span></span></div>
                            <div class="intInner">
                                <div class="intArea selectWrap" style="width:490px">
                                    <select id="nationCode" data-height="150px" data-msg="" data-direction="down" title="국적정보">
                                        <c:forEach var="allNInfo" items="${allnationalInfo}" varStatus="i">
                                            <option value="${allNInfo.nationalCode}">
                                                <c:out value="${allNInfo.nationalName}"/>[<c:out value="${allNInfo.nationalCode}"/>]
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </li>
                        
                        
                       <!-- 생년월일 --> 
                        <li>
                            <div class="intWrap"><span class="tit"><label for="userBirth">생년월일</label><span
                                    class="essential">필수</span></span></div>
                            <div class="intInner">
                                <span class="intArea"><input type="text" id="userBirth" name="userBirth"
                                                             placeholder="(ex) 19900101"
                                                             style="width:490px; margin-bottom: 20px;" 
                                                             aria-required="true"
                                                             oninput="formatBirthDate(this)" 
                                                             onblur="validateBirthDate(this)">
                                <span class="alertMessage">생년월일을 입력해주세요.</span></span>
                            </div>
                        </li>
                        
                        
                        
                        <li class="intList-address">
                            <div class="intWrap"><span class="tit"><label for="address">Address</label><span
                                    class="essential">필수</span></span></div>
                            <!-- //20200528 수정 : 주소옵션(추가) -->
                            <div class="intInner">
                                <span class="intArea"><input type="text" id="postcode" name="postcode"
                                                             style="width:328px" aria-required="true" readonly></span>
                                <button type="button" class="btnSC btnM" onclick="execDaumPostcode();">우편번호 검색</button>
                            </div>
                            <div class="intInner duobuleInp">
                                <span class="intArea"><input type="text" id="address" name="address" style="width:513px"
                                                             title="주소" aria-required="true" readonly></span>
                                <span class="intArea"><input type="text" id="detailAddress" name="detailAddress"
                                                             style="width:513px" title="상세주소"
                                                             placeholder="상세주소를 입력해주세요." aria-required="true"></span>
                                <!-- 20200528 수정 : 경고문구case(추가1) -->
                                <span class="alertMessage">주소를 입력해주세요.</span><!-- 20200528 수정 : 경고문구case(추가2) -->
                                <span class="alertMessage">상세주소를 입력해주세요.</span>
                            </div>
                        </li>

                        <li>
                            <div class="intWrap"><span class="tit"><label for="eMail0">E-MAIL</label><span
                                    class="essential">필수</span></span></div>
                            <div class="intInner emailInp">
                                <span class="intArea"><input type="text" id="email1" name="email1"
                                                             onkeyup="javascript:emailDupInit();" style="width:261px"
                                                             aria-required="true"><span class="alertMessage">이메일을 입력해주세요.</span></span>
                                <span class="dash">@</span>
                                <span class="intArea"><input type="text" id="email2" name="email2"
                                                             onkeyup="javascript:emailDupInit();" style="width:261px"
                                                             aria-required="true" title="이메일주소직접입력"></span>
                                <div class="intArea selectWrap" style="width:261px">
                                    
                                    <select name="emailType" id="emailType" class="form-control"    ><option value="">직접 입력</option><option value="naver.com" >naver.com</option><option value="hanmail.net" >hanmail.net</option><option value="hotmail.com" >hotmail.com</option><option value="nate.com" >nate.com</option><option value="gmail.com" >gmail.com</option></select>
                                </div>
                                <button type="button" class="btnSC btnM" onclick="fncEmlDupChk(); return false;">중복 확인
                                </button>
                            </div>
                        </li>
                        <!-- //20200528 수정 : 버튼추가(중복 확인) + input(style="width:261px") -->
                        <!-- <li>
                            <div class="intWrap"><span class="tit"><label for="eName">REFERRER ID</label></span></div>
                            <div class="intInner duobuleInp">
                                <span class="intArea"><input type="text" id="recomdrId" name="recomdrId" maxlength="30" placeholder="추천인 아이디를 입력해주세요." style="width:515px;" onkeyup="this.value=this.value.replace(/[^a-z0-9]/gi, '');" ></span>
                            </div>
                        </li> -->
                    </ul>
                </div>
            </div>

            <div class="btnArea">
                <button type="button" class="btnSC btnL" onclick="fncCancel(); return false;">취소</button>
                <button type="button" id="join_complete" class="btnSC btnL active" onclick="fncRegist(); return false;">회원가입</button>
            </div>
        </div>
        <!-- //inner -->
        <!-- 컨텐츠 E -->
    </div>
</form>



		<!-- //container -->
       
       
       <!--S footer  -->
<jsp:include page="/WEB-INF/views/user/footer.jsp"></jsp:include>
<!--E footer  -->
       
       
       
       
	</div>
	<!-- //wrapper -->

<div class="dimmed"></div>
</body>
</html>

