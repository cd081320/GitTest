<%@page import="java.net.URLDecoder"%>
<%@page import="com.test.BoardDTO"%>
<%@page import="java.util.List"%>
<%@page import="com.util.MyUtil"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.util.DBConn"%>
<%@page import="com.test.BoardDAO"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8");
	String cp = request.getContextPath(); %>
<%
	// 이전 페이지 List.jsp 데이터 수신
	// -> 게시물 번호 수신
	String srtNum = request.getParameter("num");
	int num = 0;
	if (srtNum != null)
		num = Integer.parseInt(srtNum);
	
	// -> 페이지번호 수신
	String pageNum = request.getParameter("pageNum");
	int currentPage = 1;
	if (pageNum != null)
		currentPage = Integer.parseInt(pageNum);
	
	// 검색 키와 검색 값 수신
	String searchKey = request.getParameter("searchKey");
	String searchValue = request.getParameter("searchValue");
	
	if (searchKey != null) // 검색 기능을 통해 이 페이지가 요청되었을 경우
	{
		// 넘어온 값이 get방식이라면
		// -> get은 한글 문자열을 인코딩해서 보내기 때문에
		if (request.getMethod().equalsIgnoreCase("get"))
		{
			// 디코딩 처리
			URLDecoder.decode(searchValue, "UTF-8");
		}
	}
	else	// 검색 기능이 아닌 경우
	{
		searchKey = "subject";
		searchValue = "";
	}
	
	Connection conn = DBConn.getConnection(); 
	BoardDAO dao = new BoardDAO(conn);
	MyUtil myUtil = new MyUtil();
	
	// 전체 데이터 개수 구하기
	/* int dataCount = dao.getDataCount(); */
	int dataCount = dao.getDataCount(searchKey, searchValue);
	
	// 전체 페이지를 기준으로 총 페이지 수 계산
	int numPerPage = 10;	//- 페이지당 표시할 데이터
	int totalPage = myUtil.getPageCount(numPerPage, dataCount);
	
	
	// 전체 페이지 수 보다 표시할 페이지가 큰 경우
	// 표시할 페이지를 전체 페이지로 처리
	// ex) 데이터가 삭제되어 현재 6페이지인데 전체 5페이지
	if (currentPage > totalPage)
		currentPage = totalPage;
	
	// 데이터 베이스 가져올 시작 끝
	int start = (currentPage - 1) * numPerPage + 1;
	int end = currentPage * numPerPage;
	
	// 실제 데이터 가져오기
	/* List<BoardDTO> lists = dao.getList(start, end); */
	List<BoardDTO> lists = dao.getList(start, end, searchKey, searchValue);
	
	// 페이징 처리
	String param = "";
	
	// 검색값이 존재한다면...
	if (!searchValue.equals(""))
	{
		param += "?searchKey=" + searchKey;
		param += "&searchValue=" + searchValue;
	}
	
	String listUrl = "List.jsp" + param;
	String pageIndexList = myUtil.pageIndexList(currentPage, totalPage, listUrl);
	
	// 글 내용 보기 주소
	String articleUrl = cp + "/Article.jsp";
	
	if (param.equals(""))
		articleUrl = articleUrl + "?pageNum=" + currentPage;
	else
		articleUrl = articleUrl + param + "&pageNum=" + currentPage;
	
	DBConn.close();
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>List.jsp</title>
<link type="text/css" rel="stylesheet" href="<%=cp %>/css/style.css">
<link type="text/css" rel="stylesheet" href="<%=cp %>/css/list.css">
<script type="text/javascript">

	function sendIt()
	{
		var f = document.searchForm;
		
		// 검색 키워드에 대한 유효성 검사 코드 활용 가능~!!!
		
		f.action = "<%=cp %>/List.jsp";
		
		f.submit();
	}
	
</script>
</head>
<body>

<%-- 
<div>
	<h1><%=cp %></h1>
</div>
 --%>

<div id="bbsList">
	<div id="bbsList_title">
		게 시 판 (JDBC 연동 버전)
	</div>
	
	<div id="bbsList_header">
		<div id="leftHeader">
		
			<!-- 검색 폼 구성 -->
			<form action="" name="searchForm" method="post">
				<select name="searchKey" class="slectFiled">
					<option value="subject">제목</option>
					<option value="name">작성자</option>
					<option value="content">내용</option>
				</select>
				<input type="text" name="searchValue" class="textFiled"/>
				<input type="button" value="검색" class="btn2" onclick="sendIt()"/>
			</form>
		
		</div><!-- #leftHeader -->
		
		<div id="rightHeader">
			<input type="button" value="글올리기" class="btn2" 
			onclick="javascript:location.href='<%=cp %>/Created.jsp'"/>
		</div><!-- #rightHeader -->
		
	
		
	</div><!-- #bbsList_header -->
	
	<div id="bbsList_list">
		
		<div id="title">
			<dl>
				<dt class="num">번호</dt>
				<dt class="subject">제목</dt>
				<dt class="name">작성자</dt>
				<dt class="created">작성일</dt>
				<dt class="hitCount">조회수</dt>
			</dl>
		</div><!-- #title -->
	
		<div id="lists">
		<!-- 
			<dl>
				<dd class="num">1</dd>
				<dd class="subject">안녕하세요</dd>
				<dd class="name">김태경</dd>
				<dd class="created">2024-07-12</dd>
				<dd class="hitCount">0</dd>
			</dl>
		 -->
		<%
		for (BoardDTO dto : lists)
		{
		%>
			<dl>
				<dd class="num"><%=dto.getNum() %></dd>
				<dd class="subject">
					<a href="<%=articleUrl %>&num=<%=dto.getNum() %>">
						<%=dto.getSubject() %>
					</a>
				</dd>
				<dd class="name"><%=dto.getName() %></dd>
				<dd class="created"><%=dto.getCreated() %></dd>
				<dd class="hitCount"><%=dto.getHitCount() %></dd>
			</dl>
		<%
		}
		%>
		
		</div><!-- lists -->
	
		<div id="footer">
			<!-- <p>1 Prev 21 22 23 24 25 26 27 28 29 30 Next 42</p> -->
			<!-- <p>등록된 게시물이 존재하지 않습니다.</p> -->
			
			<p>
			<%
			if (dataCount != 0)
			{
			%>
				<%=pageIndexList %>
			<%
			}
			else
			{
			%>
				등록된 게시물이 존재하지 않습니다.
			<%
			}
			%>
			</p>
			
		</div><!-- #footer -->
	
	</div><!-- #bbsList_list -->
	
</div><!-- #bbsList -->

</body>
</html>