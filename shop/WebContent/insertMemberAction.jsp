<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	// 인증 방어 코드 : 로그인 전에만 페이지 열람 가능
	if(session.getAttribute("loginMember") != null){
		System.out.println("이미 로그인 되어 있습니다.");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 파라메터값 받기
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	String memberName = request.getParameter("memberName");
	int memberAge = Integer.parseInt(request.getParameter("memberAge"));
	String memberGender = request.getParameter("memberGender");
	//  디버깅 코드
	System.out.println(memberId + " < insertMemberAction param : memberId");
	System.out.println(memberPw + " < insertMemberAction param : memberPw");
	System.out.println(memberName + " < insertMemberAction param : memberName");
	System.out.println(memberAge + " < insertMemberAction param : memberAge");
	System.out.println(memberGender + " < insertMemberAction param : memberGender");
	//방어 코드
	if( memberId == null || memberPw == null || memberName == null || memberAge == 0 || memberGender == null){
		System.out.println("제대로된 회원가입 정보를 입력하십쇼.");
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp");
		return;
	}
	// 데이터 타입
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	paramMember.setMemberName(memberName);
	paramMember.setMemberAge(memberAge);
	paramMember.setMemberGender(memberGender);
	// 회원가입 insertMember 메서드 호출
	MemberDao memberDao = new MemberDao();
	memberDao.insertMember(paramMember);
	// 회원가입 insertMeber 메서드 호출 후 메인페이지로 이동
	response.sendRedirect(request.getContextPath()+"/index.jsp");
	return;
	
%>