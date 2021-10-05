<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest"%> <!-- request 대신 -->
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%> <!-- 파일이름중복을 피할수 있도록 -->
<%
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		System.out.println("관리자계정으로 로그인하십시오.");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// int ebookNo = Integer.parseInt(request.getParameter("ebookNo")); 넘겨받는 형태((multipart/form-data)가 달라 사용불가
	// reqeust, 저장 주소, 파일의 사이즈, 인코딩값, DefaultFileRenammePolicy()객체		
	MultipartRequest mr = new MultipartRequest(request, "C:/Users/admin/Desktop/git-shop/shop/WebContent/image", 1024*1024*1024, "utf-8", new DefaultFileRenamePolicy());
	int ebookNo = Integer.parseInt(mr.getParameter("ebookNo"));
	String preEbookImg = mr.getParameter("preEbookImg");
	System.out.println(preEbookImg);
	String ebookImg = mr.getFilesystemName("ebookImg");
	System.out.println(ebookImg);
	Ebook ebook = new Ebook();
	ebook.setEbookNo(ebookNo);
	ebook.setEbookImg(ebookImg);
	
	EbookDao ebookDao = new EbookDao();
	ebookDao.updateEbookImg(ebook, preEbookImg);
	response.sendRedirect(request.getContextPath()+"/admin/selectEbookOne.jsp?ebookNo="+ebookNo);
%>