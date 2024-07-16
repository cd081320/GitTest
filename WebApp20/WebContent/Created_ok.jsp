<%@page import="com.test.BoardDTO"%>
<%@page import="com.test.BoardDAO"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.util.DBConn"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8");
   String cp = request.getContextPath(); %>
   
<jsp:useBean id="dto" class="com.test.BoardDTO" scope="page"></jsp:useBean>
<jsp:setProperty property="*" name="dto"/>

<%
	// Created_ok.jsp
	
	// db 연결
	Connection conn = DBConn.getConnection();
	BoardDAO dao = new BoardDAO(conn);
	
	dto.setNum(dao.getMaxNum() + 1);
	// 클라이언트 브라우저의 IP Address 확인
	dto.setIpAddr(request.getRemoteAddr());
	
	// insert 처리
	dao.insertData(dto);
	
	// db 연결 해제
	DBConn.close();
	
	// 리다이렉트
	response.sendRedirect("List.jsp");
%>