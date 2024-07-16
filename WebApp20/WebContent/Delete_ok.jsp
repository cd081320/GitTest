<%@page import="com.test.BoardDAO"%>
<%@page import="com.util.DBConn"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8");
   String cp = request.getContextPath(); %>
<%
	// 이전 페이지 Updated.jsp 데이터 수신
	// num, pageNum
	String pageNum = request.getParameter("pageNum");
	int num = Integer.parseInt(request.getParameter("num"));	

	// dao
	Connection conn = DBConn.getConnection();
	BoardDAO dao = new BoardDAO(conn);
	
	int result = dao.deleteData(num);
	
	// result 값에 따른 분기 처리 가능s
	DBConn.close();
	
	response.sendRedirect(cp + "/List.jsp?pageNum=" + pageNum);
%>