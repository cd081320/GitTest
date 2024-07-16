<%@page import="com.util.DBConn"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.test.BoardDAO"%>
<%@page import="com.test.BoardDTO"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8");
   String cp = request.getContextPath(); %>
<jsp:useBean id="dto" class="com.test.BoardDTO"></jsp:useBean>
<jsp:setProperty property="*" name="dto"/>
<%
	Connection conn = DBConn.getConnection();
	BoardDAO dao = new BoardDAO(conn);
	String pageNum = request.getParameter("pageNum");
	int num = Integer.parseInt(request.getParameter("num"));
	
	dao.updateHitCount(num);

	// 이전글, 다음글 게시물 번호 확인
	int prevNum = dao.getBeforeNum(num);
	int nextNum = dao.getNextNum(num);
	
	
	// 이전글, 다음글 제목 얻어오기
	BoardDTO prevData = null;
	BoardDTO nextData = null;
	
	if (prevNum != -1)
		prevData = dao.getReadData(prevNum);
	
	if (nextNum != -1)
		nextData = dao.getReadData(nextNum);
	
	// 해당 게시물의 상세 내용 가져오기
	BoardDTO readData = dao.getReadData(dto.getNum());
	
	// 게시물 본문 라인 수 확인
	int lineCount = readData.getContent().split("\n").length;
	readData.setContent(readData.getContent().replaceAll("\n", "<br>"));
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Article.jsp</title>
<link type="text/css" rel="stylesheet" href="<%=cp %>/css/style.css">
<link type="text/css" rel="stylesheet" href="<%=cp %>/css/article.css">
</head>
<body>

<div id="bbs">
	<div id="bbs_title">
		게 시 판 (JDBC 연동 버전)
	</div>
	
	<div id="bbsArticle">
		
		<div id="bbsArticle_header">
			게시물의 제목
		</div>
		
		<div class="bbsArticle_bottomLine">
			<dl>
				<dt>작성자</dt>
				<!-- <dd>박서영</dd> -->
				<dd><%=readData.getName() %></dd>
				
				<dt>라인수</dt>
				<!-- <dd>23</dd> -->
				<dd><%=lineCount %></dd>
			</dl>
		</div><!-- .bbsArticle_bottomLine -->
				
		<div class="bbsArticle_bottomLine">
			<dl>
				<dt>등록일</dt>
				<!-- <dd>2024-07-12</dd> -->
				<dd><%=readData.getCreated() %></dd>
				
				<dt>조회수</dt>
				<!-- <dd>13</dd> -->
				<dd><%=readData.getHitCount() %></dd>
			</dl>
		</div><!-- .bbsArticle_bottomLine -->
				
		<div id="bbsAricle_content">
			<table style="width: 600px;">
				<tr>
					<td style="padding: 40px 40px 10px 40px; vertical-align: top; height: 150px;">
						<%=readData.getContent() %>
					</td>
				</tr>
			</table>
		</div><!-- #bbsAricle_content -->
		<div class="bbsArticle_bottomLine">
			<!-- 이전글 : (104) 취미 관련 게시물 -->
			<%
			if (prevNum != -1)
			{
			%>
				<a href="<%=cp %>/Article.jsp?pageNum=<%=pageNum %>&num=<%=prevNum %>">
					이전글 : (<%=prevNum %>) <%=prevData.getSubject() %>
				</a>
			<%
			}
			else
			{
			%>
				이전글 : 없음
			<%
			}
			%>
		</div><!-- .bbsArticle_bottomLine -->
		
		<div class="bbsArticle_noLine">
			<!-- 다음글 : (102) 날씨 관련 게시물 -->
			<%
			if (nextNum != -1)
			{
			%>
				<a href="<%=cp %>/Article.jsp?pageNum=<%=pageNum %>&num=<%=nextNum %>">
					다음글 : (<%=nextNum %>) <%=nextData.getSubject() %>
				</a>
			<%
			}
			else
			{
			%>
				다음글 : 없음
			<%
			}
			%>
		</div><!-- .bbsArticle_noLine -->
		
	</div><!-- #bbsArticle -->
	
	<div class="bbsArticle_noLine" style="text-align: right;">
		<!-- From : 211.238.142.159 -->
		From : <%=readData.getIpAddr() %>
	</div><!-- .bbsArticle_noLine -->
	
	<div id="bbsArticle_footer">
		
		<div id="leftFooter">
			<input type="button" value="수정" class="btn2" 
			onclick="javascript:location.href='<%=cp %>/Updated.jsp?num=<%=dto.getNum() %>&pageNum=<%=pageNum %>&status=1'"/>
			<input type="button" value="삭제" class="btn2" 
			onclick="javascript:location.href='<%=cp %>/Updated.jsp?num=<%=dto.getNum() %>&pageNum=<%=pageNum %>&status=2'"/>
		</div><!-- #leftFooter -->
		
		<div id="rightFooter">
			<input type="button" value="리스트" class="btn2"
			onclick="javascript:location.href='<%=cp %>/List.jsp?pageNum=<%=pageNum %>'"/>
		</div><!-- #rightFooter -->
		
	</div><!-- #bbsArticle_footer -->
	
</div><!-- #bbs -->

</body>
</html>