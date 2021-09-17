<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div>
	<h5>
		<nav class="navbar navbar-expand-sm bg-light navbar-light">
		  <ul class="navbar-nav">
		    <li class="nav-item active">
		      <a class="nav-link" href="<%=request.getContextPath()%>/admin/selectMemberList.jsp">[회원 관리]</a>
		    </li>
		    <!--
		    	전자책 카테고리 관리 : 목록, 추가, 사용유무 수정
		    	1. Category.class
		    	2. CategoryDao.class
		    	3. selectCategoryList.jsp
		    	4. insertCategoryForm.jsp
		    	5. insertCategoryAction.jsp
		    	6. selectCategoryNameCheckAction.jsp
		    	7. updateCategoryStateAction.jsp
		    -->
		    <li class="nav-item active">
		      <a class="nav-link" href="<%=request.getContextPath()%>/admin/selectCategoryList.jsp">[전자책 카테고리 관리]</a>
		    </li>
		    <!-- 전자책 관리 : 목록, 추가(이미지추가), 수정, 삭제-->
		    <li class="nav-item active">
		      <a class="nav-link" href="<%=request.getContextPath()%>/admin/">[전자책 관리]</a>
		    </li>
		    <li class="nav-item active">
		      <a class="nav-link" href="<%=request.getContextPath()%>/admin/">[주문  관리]</a>
		    </li>
		    <li class="nav-item active">
		      <a class="nav-link" href="<%=request.getContextPath()%>/admin/">[상품평 관리]</a>
		    </li>
		    <li class="nav-item active">
		      <a class="nav-link" href="<%=request.getContextPath()%>/admin/">[공지게시판  관리]</a>
		    </li>
		    <li class="nav-item active">
		      <a class="nav-link" href="<%=request.getContextPath()%>/admin/">[QnA게시판 관리]</a>
		    </li>
		  </ul>
		</nav>
	</h5>
</div>