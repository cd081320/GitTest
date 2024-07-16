<%@page import="com.util.DBConn"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.test.BoardDAO"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8");
   String cp = request.getContextPath(); %>
<jsp:useBean id="data" class="com.test.BoardDTO"></jsp:useBean>
<jsp:setProperty property="*" name="data"/>
<%
	// 이전 페이지 Updated.jsp 데이터 수신
	// num, pageNum
	String pageNum = request.getParameter("pageNum");
	
	// dao
	Connection conn = DBConn.getConnection();
	BoardDAO dao = new BoardDAO(conn);
	
	int result = dao.updateData(data);
	
	// result 값에 따른 분기 처리 가능
	DBConn.close();
	
	response.sendRedirect(cp + "/List.jsp?num="+ data.getNum() + "&pageNum=" + pageNum);
%>