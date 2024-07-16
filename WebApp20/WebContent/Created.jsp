<%@ page contentType="text/html; charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8");
   String cp = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Created.jsp</title>
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
			alert("\n내용을 입려려세요~!!!");
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
		
		f.action = "<%=cp%>/Created_ok.jsp";
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
						<input type="text" name="subject" maxlength="100" class="boxTF" style="width: 480px;">
					</dd>
				</dl>
			</div><!-- .bbsCreated_bottomLine -->
			
			<div class="bbsCreated_bottomLine">
				<dl>
					<dt>작 성 자</dt>
					<dd>
						<input type="text" name="name" max="20" class="boxTF" style="width: 320px;"/>
					</dd>
				</dl>
			</div><!-- .bbsCreated_bottomLine -->
			
			<div class="bbsCreated_bottomLine">
				<dl>
					<dt>이 메 일</dt>
					<dd>
						<input type="text" name="email" max="20" class="boxTF" style="width: 320px;"/>
					</dd>
				</dl>
			</div><!-- .bbsCreated_bottomLine -->

			<div id="bbsCreated_content">
				<dl>
					<dt>내&nbsp;&nbsp;&nbsp;&nbsp;용</dt>
					<dd>
						<textarea name="content" class="boxTA" cols="63" rows="12"></textarea>
					</dd>
				</dl>
			</div><!-- .bbsCreated_bottomLine -->
			
			<div class="bbsCreated_bottomLine">
				<dl>
					<dt>패스워드</dt>
					<dd>
						<input type="password" name="pwd" maxlength="10" class="boxTF" style="width: 280px;"/>
						&nbsp;
						<span style="font-size: 7pt;">(게시물 수정 및 삭제 시 필요)</span>
					</dd>
				</dl>
			</div><!-- .bbsCreated_bottomLine -->		
			
			<div id="bbsCreated_footer">
				<input type="button" value="등록하기" class="btn2" onclick="sendIt()"/>
				<input type="reset" value="다시입력" class="btn2" onclick="document.myForm.subject.focus();"/>
				<input type="button" value="작성취소" class="btn2"
				 onclick="javascipt:location.href='<%=cp %>/List.jsp'"/>
			</div><!-- #bbsCreated_footer -->
			
		</div><!-- #bbsCreated -->
	</form>

</div><!-- #bbs -->

</body>
</html>