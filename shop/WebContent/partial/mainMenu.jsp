<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%
	Member loginMember = (Member)session.getAttribute("loginMember");
 %>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<div>
	<h5>
		<nav class="navbar navbar-expand-sm bg-light navbar-light">
			<div class="container-fluid" style="text-align:right">
				<ul class="navbar-nav">
				    <li class="nav-item active">
				      <a class="nav-link" href="<%=request.getContextPath()%>/index.jsp">[홈으로]</a>
				    </li>
				    <li class="nav-item active">
				      <a class="nav-link" href="<%=request.getContextPath()%>/selectOrderListByMember.jsp">[내 주문]</a>
				    </li>
				    <li class="nav-item active">
				      <a class="nav-link" href="<%=request.getContextPath()%>/selectNoticeList.jsp">[공지사항]</a>
				    </li>
				    <li class="nav-item active">
				      <a class="nav-link" href="<%=request.getContextPath()%>/selectQnaList.jsp">[QnA게시판]</a>
				    </li>
				</ul>
			  </div>
		</nav>
	</h5>
</div>