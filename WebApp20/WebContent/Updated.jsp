<%@page import="com.util.DBConn"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.test.BoardDAO"%>
<%@page import="com.test.BoardDTO"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8");
   String cp = request.getContextPath(); %>
<%
	// 이전 페이지 Article.jsp 데이터 수신
	// num, pageNum
	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	int num	= Integer.parseInt(request.getParameter("num"));
	
	// 수정 및 삭제를 분기하는 과정에서 추가한 코드
	String statusStr = request.getParameter("status");
	int status = Integer.parseInt(statusStr);
	
	// dao
	Connection conn = DBConn.getConnection();
	BoardDAO dao = new BoardDAO(conn);
	
	// 수정 전 데이터
	BoardDTO data = dao.getReadData(num);
	
	String emailStr = "";
	if (data.getEmail() != null)
		emailStr = data.getEmail();
	
	DBConn.close();
	
	if (data == null)
		response.sendRedirect("List.jsp");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Updated.jsp</title>
<link type="text/css" rel="stylesheet" href="<%=cp %>/css/style.css">
<link type="text/css" rel="stylesheet" href="<%=cp %>/css/created.css">
<script type="text/javascript" src="<%=cp %>/js/util.js"></script>
<script type="text/javascript">
	function sendIt()
	{
		f = document.myForm;

		// 제목 입력 확인
		// 필수 입력 항목 기재 여부 확인 및 공백 처리
		var str = f.subject.value;
		str = str.trim();
		
		//테스트
		//alert("|" + str + "|");
		
		if (!str)
		{
			alert("\n제목을 입력하세요~!!!");
			f.subject.focus();
			return;
		}
		
		// 이름 입력 확인
		str = f.name.value;
		str = str.trim();
		
		if (!str)
		{
			alert("\n작성자의 이름을 입력하세요~!!!");
			f.name.focus();
			return;
		}
		
		// 이메일 검사
		if (f.email.value)
		{
			if (!isValidEmail(f.email.value))
			{
				alert("\n정상적인 이메일 형식을 입력하세요~!!!");
				f.email.focus();
				return;
			}
		}
		
		// 내용 입력 확인
		str = f.content.value;
		str = str.trim();
		
		if (!str)
		{
			alert("\n내용을 입력하세요~!!!");
			c.ontent.focus();
			return;
		}
		
		// 패스워드 입력 화인
		str = f.pwd.value;
		st = str.trim();
		
		if (!str)
		{
			alert("\n패스워드를 입력하세요~!!!");
			f.pwd.focus();
			return;
		}
		
		// 패스워드 일치여부 확인
		// 게시물 최초 작성 시 설정한 패스워드와 일치하는지 확인하여 액션 처리
		var pwdSource = f.pwdSource.value;
		if (str != pwdSource)
		{
			alert("\n패스워드가 일치하지 않습니다~!!!");
			f.pwd.feocus();
			return;
		}
		
		
		f.action = "<%=cp %>/Updated_ok.jsp";
		f.submit();
	}
	
	function removeIt()
	{
		f = document.myForm;
		
		// 패스워드 입력 화인
		var str = f.pwd.value;
		st = str.trim();
		
		if (!str)
		{
			alert("\n패스워드를 입력하세요~!!!");
			f.pwd.focus();
			return;
		}
		
		// 패스워드 일치여부 확인
		// 게시물 최초 작성 시 설정한 패스워드와 일치하는지 확인하여 액션 처리
		var pwdSource = f.pwdSource.value;
		if (str != pwdSource)
		{
			alert("\n패스워드가 일치하지 않습니다~!!!");
			f.pwd.feocus();
			return;
		}
		
		f.action = "<%=cp %>/Delete_ok.jsp";
		f.submit();
	}
	
	
</script>
</head>
<body>

<div id="bbs">

	<div id="bbs_title">
		게 시 판 (JDBC 연동 버전)
	</div><!-- #bbs_title -->

	<form action="" method="post" name="myForm">
	
		<div id="bbsCreated">
		
			<div class="bbsCreated_bottomLine">
				<dl>
					<dt>제&nbsp;&nbsp;&nbsp;&nbsp;목</dt>
					<dd>
						<%
						if (status == 1)	// 수정 요청
						{
						%>
							<input type="text" name="subject" maxlength="100" value="<%=data.getSubject() %>"
							class="boxTF" style="width: 480px;">
						<%
						}
						else				// 삭제 요청
						{
						%>
							<input type="text" name="subject" maxlength="100" value="<%=data.getSubject() %>"
							class="boxTF" style="width: 480px;" disabled="disabled">
						<%
						}
						%>
					</dd>
				</dl>
			</div><!-- .bbsCreated_bottomLine -->
			
			<div class="bbsCreated_bottomLine">
				<dl>
					<dt>작 성 자</dt>
					<dd>
						<%
						if (status == 1)
						{
						%>
							<input type="text" name="name" max="20" value="<%=data.getName() %>"
							class="boxTF" style="width: 320px;"/>
						<%
						}
						else
						{
						%>
							<input type="text" name="name" max="20" value="<%=data.getName() %>"
							class="boxTF" style="width: 320px;" disabled="disabled"/>
						<%
						}
						%>
					</dd>
				</dl>
			</div><!-- .bbsCreated_bottomLine -->
			
			<div class="bbsCreated_bottomLine">
				<dl>
					<dt>이 메 일</dt>
					<dd>
						<%
						if (status == 1)
						{
						%>
							<input type="text" name="email" max="20" value="<%=emailStr %>"
							class="boxTF" style="width: 320px;"/>
						<%
						}
						else
						{
						%>
							<input type="text" name="email" max="20" value="<%=emailStr %>"
							class="boxTF" style="width: 320px;" disabled="disabled"/>
						<%
						}
						%>
					</dd>
				</dl>
			</div><!-- .bbsCreated_bottomLine -->

			<div id="bbsCreated_content">
				<dl>
					<dt>내&nbsp;&nbsp;&nbsp;&nbsp;용</dt>
					<dd>
						<%
						if (status == 1)
						{
						%>
							<textarea name="content" class="boxTA" cols="63" rows="12"
							><%=data.getContent().replaceAll("<br>", "\n") %></textarea>
						<%
						}
						else
						{
						%>
							<textarea name="content" class="boxTA" cols="63" rows="12" disabled="disabled"
							><%=data.getContent().replaceAll("<br>", "\n") %></textarea>
						<%
						}
						%>
					</dd>
				</dl>
			</div><!-- .bbsCreated_bottomLine -->
			
			<div class="bbsCreated_bottomLine">
				<dl>
					<dt>패스워드</dt>
					<dd>
						<input type="hidden" name="pwdSource" value="<%=data.getPwd() %>"/>
						<input type="password" name="pwd" maxlength="10" class="boxTF" style="width: 280px;"/>
						&nbsp;
						<span style="font-size: 7pt;">(게시물 수정 및 삭제 시 필요)</span>
					</dd>
				</dl>
			</div><!-- .bbsCreated_bottomLine -->		
			
			<div id="bbsCreated_footer">
				<!-- Updated_ok.jsp 페이지 요청 과정에서 추가로 필요한 데이터 -->
				<input type="hidden" name="num" value="<%=data.getNum() %>">
				<input type="hidden" name="pageNum" value="<%=pageNum %>"/>
				<%
				if (status == 1)
				{
				%>
					<input type="button" value="수정하기" class="btn2" onclick="sendIt()"/>
					<input type="reset" value="다시입력" class="btn2" 
					onclick="document.myForm.subject.focus();"/>
					<input type="button" value="수정취소" class="btn2"
					 onclick="javascipt:location.href='<%=cp %>/List.jsp?pageNum=<%=pageNum %>'"/>
				<%
				}
				else
				{
				%>
					<input type="button" value="삭제하기" class="btn2" onclick="removeIt()"/>
					<input type="button" value="삭제취소" class="btn2"
					 onclick="javascipt:location.href='<%=cp %>/List.jsp?pageNum=<%=pageNum %>'"/>
				<%
				}
				%>
			</div><!-- #bbsCreated_footer -->
			
		</div><!-- #bbsCreated -->
	</form>

</div><!-- #bbs -->

</body>
</html>