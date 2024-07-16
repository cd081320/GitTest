/*=======================
 * MyUtil.java
 * - 게시판 페이징 처리
=======================*/

// check
// 이번 페이징 처리 기법은
// 다양한 방법들 중 한가지
// 이후 개념을 정리하고 다른 방법도 찾아보며 공부하기

package com.util;

public class MyUtil
{
	// ■ 전체 페이지 수 구하는 메소드
	// numPerPage: 한 페이지에 표시할 데이터 수
	// dataCount: 전체 데이터 수
	public int getPageCount(int numPerPage, int dataCount)
	{
		int pageCount = 0;
		
		pageCount = dataCount / numPerPage;	// 페이지 개수 
		
		if (dataCount%numPerPage != 0)		// 나머지가 남아 있다면
			pageCount++;					// 페이지 개수 + 1
		
		return pageCount;
	}
	
	
	// ■ 페이징 처리 기능의 메소드
	// currentPage: 현재 표시할 페이지
	// totalPage: 전체 페이지 수
	// listUrl: 링크 설정할 url
	public String pageIndexList(int currentPage, int totalPage, String listUrl)
	{
		// 실제 페이징을 저장할 StringBuffer 변수
		StringBuffer strList = new StringBuffer();
		
		int numPerBlock = 10;
		//- 리스트 하단의 숫자의 개수
		

		int currentPageSetup;
		//- numPerBlock의 배수, 1~10 -> 0, 11~20 -> 10, 21~30 -> 20
		
		int page;
		int n;
		//- 이전 페이지 블럭과 같은 처리에서 이동하기 위한 변수
		//  (얼마만큼 이동해야 하는지)
		
		// 1페이지도 채워지지 않은 경우, 데이터가 존재하지 않는 경우
		// -> 페이징 처리가 별도로 필요하지 않은 경우
		if (currentPage==0)
			return "";
		
		// ※ 페이지 요청을 처리하는 과정에서
		//   URL 경로의 패턴에 대한 처리
		/*
		 * - 클라이언트 요청의 형태 
		 * 
		 *   List.jsp -> (가공) -> List.jsp + 『?』 + 『pageNum=1』
		 * 							
		 *   List.jsp?subject=study -> (가공) -> List.jsp?subject=study + 『&』 + 『pageNum=1』
		 * 
		 */
		
		// get방식 전처리
		if (listUrl.indexOf("?") != -1)	// 링크를 설정할 URL에 ?가 들어있으면
		{
			listUrl = listUrl + "&";
		}
		else							// 링크를 설정할 URL에 ?가 들어있지 않으면
		{
			listUrl = listUrl + "?";
		}
		//- 예를 들어, 검색값이 존재하면
		//  이미 requset 값에 searchKey 값과 searchValue 값이 들어있는 상황이므로
		//  『&』를 붙여서 속성값에 추가해 주어야 한다.
		
		// currentPageSetup 표시할 첫 페이지 - 1
		currentPageSetup = (currentPage / numPerBlock) * numPerBlock;
		//- 현재 페이지가 속해있는 리스트의 시작 위치
		
		// 맨 마지막 페이지의 경우
		if (currentPage % numPerBlock == 0)
		{
			currentPageSetup = currentPageSetup - numPerBlock;
		}
		//- 맨 마지막 페이지는 나누어 떨어지기 때문에(라인 78) 값이 numPerBlock만큼 커진다.
		//  이것을 빼주어 계산.
		//  ex) 20 / 10 * 10 -> 20 인데 currentPageSetup은 10이여야 하기 때문에 -10
		
		
		// 1페이지
		if ( (totalPage > numPerBlock) && (currentPageSetup > 0) )
		{
			strList.append("<a href='" + listUrl + "pageNum=1'>1</a>");
		}
		
		// Prev(이전으로)
		n = currentPage - numPerBlock;
		//- 해당 페이지만큼 앞으로 가기 위한 변수
		//  ex) 12페이지에서 Prev 누르면 2페이지
		
		if ( (totalPage > numPerBlock) && (currentPageSetup > 0) )
		{
			strList.append(" <a href='" + listUrl + "pageNum=" + n + "'>Prev</a>");
		}
		
		// 각 페이지 바로가기
		page = currentPageSetup + 1;
		//- 출력할 페이지 준비
		while ( (page <= totalPage) && (page <= currentPageSetup+numPerBlock) )
		{
			if (page == currentPage)
			{
				strList.append(" <span style='color:orange; font-weight: bold;'>" + page + "</span>");
			}
			else
			{
				strList.append(" <a href='" + listUrl + "pageNum=" + page + "'>" + page + "</a>");
			}
			page++;
		}
		
		
		// Next(다음으로)
		n = currentPage + numPerBlock;
		if ( (totalPage - currentPageSetup) > numPerBlock )
		{
			strList.append(" <a href='" + listUrl + "pageNum=" + n + "'>Next</a>");
		}
		
		// 마지막 페이지(맨마지막으로)
		if ( (totalPage > numPerBlock) && (currentPageSetup + numPerBlock) < totalPage)
		{
			strList.append(" <a href='" + listUrl + "pageNum=" + totalPage + "'>" + totalPage + "</a>");
		}
		
		return strList.toString();
	}
}
