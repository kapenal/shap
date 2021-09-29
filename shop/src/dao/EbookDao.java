package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import commons.DBUtil;
import vo.Ebook;
import vo.OrderComment;

public class EbookDao {
	// 총 후기 갯수
	public int orderCommentCount(int ebookNo) throws ClassNotFoundException, SQLException {
		// 리턴값
		int count = 0;
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    // 쿼리문 생성
	    String sql = "SELECT COUNT(ebook_no) count FROM order_comment WHERE ebook_no = ? GROUP BY ebook_no";
	    // 쿼리문 실행
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, ebookNo);
	    System.out.println(stmt + " < EbookDao.orderCommentCount stmt");
	    ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			count = rs.getInt("count");
		}
	    return count;
	}
	
	// [고객] 후기 출력
	public ArrayList<OrderComment> selectCommentList(int ebookNo, int beginRow, int orderCommentRowPerPage) throws ClassNotFoundException, SQLException {
		ArrayList<OrderComment> list = new ArrayList<>();
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
		String sql = "SELECT order_no orderNo, ebook_no ebookNo, order_score orderScore, order_comment_content orderCommentContent, create_date createDate, update_date updateDate FROM order_comment WHERE ebook_no=? ORDER BY create_date DESC Limit ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ebookNo);
		stmt.setInt(2, beginRow);
		stmt.setInt(3, orderCommentRowPerPage);
		System.out.println(stmt + " < EbookDao.selectCommentList stmt");
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			OrderComment orderComment = new OrderComment();
			orderComment.setOrderNo(rs.getInt("orderNo"));
			orderComment.setOrderNo(rs.getInt("ebookNo"));
			orderComment.setOrderScore(rs.getInt("orderScore"));
			orderComment.setOrderCommentContent(rs.getString("orderCommentContent"));
			orderComment.setCreateDate(rs.getString("createDate"));
			list.add(orderComment);
		}
		// 자원 해제
		stmt.close();
		conn.close();
		rs.close();
		return list;
	}
	
	// [고객] 신상 전자책 목록(5개) 출력
	public ArrayList<Ebook> selectNewProductEbookList(	) throws ClassNotFoundException, SQLException{
		/*
		 *  SELECT *
		 *	FROM ebook
		 *	ORDER BY create_date DESC
		 *	LIMIT 0, 5
		 */
		// 리턴값
		ArrayList<Ebook> list = new ArrayList<>();
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement stmt = null;
		// 쿼리문 생성, 실행
		String sql = "SELECT ebook_no ebookNo, ebook_title ebookTitle, ebook_price ebookPrice, ebook_img ebookImg FROM ebook ORDER BY create_date DESC LIMIT 0, 5";
		stmt = conn.prepareStatement(sql);
		// 디버깅
		System.out.println(stmt + " < EbookDao.selectNewProductEbookList stmt");
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Ebook ebook = new Ebook();
			ebook.setEbookNo(rs.getInt("ebookNo"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookPrice(rs.getInt("ebookPrice"));
			ebook.setEbookImg(rs.getString("ebookImg"));
			list.add(ebook);
         }
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return list;
	}
	
	// [고객] 인기 전자책 목록(5개) 출력
	public ArrayList<Ebook> selectPopularEbookList(	) throws ClassNotFoundException, SQLException{
		/*
		 *  SELECT e.*, t.*
		 *	FROM	ebook e INNER JOIN	(SELECT ebook_no, COUNT(ebook_no) FROM orders
		 *	GROUP BY ebook_no
		 *	ORDER BY COUNT(ebook_no) DESC
		 *	LIMIT 0,5) t
		 *	ON e.ebook_no = t.ebook_no
		 */
		// 리턴값
		ArrayList<Ebook> list = new ArrayList<>();
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement stmt = null;
		// 쿼리문 생성, 실행
		String sql = "SELECT t.ebook_no ebookNo, e.ebook_title ebookTitle, e.ebook_price ebookPrice, e.ebook_img ebookImg FROM ebook e INNER JOIN (SELECT ebook_no, COUNT(ebook_no) FROM orders GROUP BY ebook_no ORDER BY COUNT(ebook_no) DESC LIMIT 0,5) t ON e.ebook_no = t.ebook_no";
		stmt = conn.prepareStatement(sql);
		// 디버깅
		System.out.println(stmt + " < EbookDao.selectPopularEbookList stmt");
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Ebook ebook = new Ebook();
			ebook.setEbookNo(rs.getInt("ebookNo"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookPrice(rs.getInt("ebookPrice"));
			ebook.setEbookImg(rs.getString("ebookImg"));
			list.add(ebook);
         }
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return list;
	}
	
	//  [관리자] 가격 수정
	public void updateEbookPrice(Ebook ebook) throws ClassNotFoundException, SQLException {
		// DB연결 메서드 호출  
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성, 실행
		String sql="UPDATE ebook SET ebook_price=?, update_date=Now() WHERE ebook_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ebook.getEbookPrice());
		stmt.setInt(2, ebook.getEbookNo());
		// 디버깅
		System.out.println(stmt + "< EbookDao.updateEbookPrice stmt");
		stmt.executeUpdate();
		//자원 해제
		conn.close();
		stmt.close();
	}
	
	// [관리자] Ebook삭제
	public void deleteEbook(int ebookNo) throws ClassNotFoundException, SQLException {
		// 매개변수 디버깅
		System.out.println(ebookNo + " < EbookDao.deleteMemberByKey param : ebookNo");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "DELETE FROM ebook WHERE ebook_no=?";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ebookNo);
		// 디버깅
		System.out.println(stmt + " < EbookDao.deleteMemeberByKey stmt");
		int row = stmt.executeUpdate();
		if(row == 1) {
			System.out.println("Ebook 삭제 완료");
		}
		//자원 해제
		conn.close();
		stmt.close();
	}
	
	// [관리자] 이미지 수정
	public void updateEbookImg(Ebook ebook) throws ClassNotFoundException, SQLException {
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "UPDATE ebook SET ebook_img=?, update_date=Now() WHERE ebook_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, ebook.getEbookImg());
		stmt.setInt(2, ebook.getEbookNo());
		System.out.println(stmt);
		stmt.executeUpdate();
		// 자원 해제
		stmt.close();
		conn.close();
	}
	
	
	// [관리자] 상세보기
	public Ebook selectEbookOne(int ebookNo) throws ClassNotFoundException, SQLException {
		Ebook ebook = null;
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT ebook_no ebookNo, ebook_isbn ebookIsbn, category_name categoryName, ebook_title ebookTitle, ebook_author ebookAuthor, ebook_company ebookCompany, ebook_page_count ebookPageCount, ebook_price ebookPrice, ebook_img ebookImg, ebook_summary ebookSummary, ebook_state ebookState, create_date createDate, update_date updateDate  FROM ebook WHERE ebook_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ebookNo);
		System.out.println(stmt+ "< selectEbookOne stmt");
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			ebook = new Ebook();
			ebook.setEbookNo(rs.getInt("ebookNo"));
			ebook.setEbookIsbn(rs.getString("ebookIsbn"));
			ebook.setCategoryName(rs.getString("categoryName"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookAuthor(rs.getString("ebookAuthor"));
			ebook.setEbookCompany(rs.getString("ebookCompany"));
			ebook.setEbookPageCount(rs.getInt("ebookPageCount"));
			ebook.setEbookPrice(rs.getInt("ebookPrice"));
			ebook.setEbookSummary(rs.getString("ebookSummary"));
			ebook.setEbookState(rs.getString("ebookState"));
			ebook.setCreateDate(rs.getString("createDate"));
			ebook.setUpdateDate(rs.getString("updateDate"));
			ebook.setEbookImg(rs.getString("ebookImg"));
		}
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return ebook;
	}
	
	
	// [관리자 & 고객]전체 전자책 목록 출력
	public ArrayList<Ebook> selectEbookList(int beginRow, int ROW_PER_PAGE, String searchEbookTitle) throws ClassNotFoundException, SQLException{
		/*
		 *  SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState FROM ebook ORDER BY create_date DESC LIMit ? , ?
		 */
		// 리턴값
		ArrayList<Ebook> list = new ArrayList<>();
		// 매개변수 디버깅
		System.out.println(beginRow + "< EbookDao.selectEbookList param : geginRow");
		System.out.println(ROW_PER_PAGE + "< EbookDao.selectEbookList param : ROW_PER_PAGE");
		System.out.println(searchEbookTitle + "< EbookDao.selectEbookList param : searchEbookTitle");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement stmt = null;
		if(searchEbookTitle.equals("")== true) {
			// 쿼리문 생성
			String sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_price ebookPrice, ebook_img ebookImg, ebook_state ebookState FROM ebook ORDER BY create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, beginRow);
			stmt.setInt(2, ROW_PER_PAGE);
		} else {
			// 쿼리문 생성
			String sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_price ebookPrice, ebook_img ebookImg, ebook_state ebookState FROM ebook  WHERE ebook_title LIKE ? ORDER BY create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchEbookTitle+"%");
			stmt.setInt(2, beginRow);
			stmt.setInt(3, ROW_PER_PAGE);
		}
		
		// 디버깅
		System.out.println(stmt + " < EbookDao.selectEbookList stmt");
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Ebook ebook = new Ebook();
			ebook.setEbookNo(rs.getInt("ebookNo"));
			ebook.setCategoryName(rs.getString("categoryName"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookPrice(rs.getInt("ebookPrice"));
			ebook.setEbookImg(rs.getString("ebookImg"));
			ebook.setEbookState(rs.getString("ebookState"));
			list.add(ebook);
         }
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return list;
	}
	
	// 특정 카테고리 전자책 출력
	public ArrayList<Ebook> selectEbookListByCategory(int beginRow, int ROW_PER_PAGE, String categoryName, String searchEbookTitle) throws ClassNotFoundException, SQLException{
		/*
		 *  SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState FROM ebook WHERE category_name=? ORDER BY create_date DESC LIMit ? , ?
		 */
		ArrayList<Ebook> list = new ArrayList<>();
		// 매개변수 디버깅
		System.out.println(beginRow + "< EbookDao.selectEbookListByCategory param : geginRow");
		System.out.println(ROW_PER_PAGE + "< EbookDao.selectEbookListByCategory param : ROW_PER_PAGE");
		System.out.println(categoryName + "< EbookDao.selectEbookListByCategory param : categoryName");
		System.out.println(searchEbookTitle + "< EbookDao.selectEbookListByCategory param : searchEbookTitle");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement stmt = null;
		if(searchEbookTitle.equals("")== true) {
			// 쿼리문 생성
			String sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState FROM ebook WHERE category_name=? ORDER BY create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, categoryName);
			stmt.setInt(2, beginRow);
			stmt.setInt(3, ROW_PER_PAGE);
		}else {
			// 쿼리문 생성
			String sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState FROM ebook WHERE category_name=? AND ebook_title LIKE ? ORDER BY create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, categoryName);
			stmt.setString(2, "%"+searchEbookTitle+"%");
			stmt.setInt(3, beginRow);
			stmt.setInt(4, ROW_PER_PAGE);
		}
		
		// 디버깅
		System.out.println(stmt + " < EbookDao.selectEbookListByCategory stmt");
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Ebook ebook = new Ebook();
			ebook.setEbookNo(rs.getInt("ebookNo"));
			ebook.setCategoryName(rs.getString("categoryName"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookState(rs.getString("ebookState"));
			list.add(ebook);
         }
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return list;
	}
	
	// [관리자] 전자책 목록의 특정 카테고리 페이지
	public int selectEbookListAllByCategoryNameTotalPage(String categoryName, String searchEbookTitle) throws ClassNotFoundException, SQLException {
		// 리턴값
		int totalCount = 0;
		// 매개변수 디버깅
		System.out.println(categoryName + "< EbookDao.selectEbookListAllByCategoryNameTotalPage param : categoryName");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement stmt = null;
		if(searchEbookTitle.equals("")== true) {
			// 쿼리문 생성
			String sql = "SELECT count(*) FROM ebook WHERE category_name=?";
			// 쿼리문 실행
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, categoryName);
		}else {
			// 쿼리문 생성
			String sql = "SELECT count(*) FROM ebook WHERE category_name=? AND ebook_title LIKE ?";
			// 쿼리문 실행
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, categoryName);
			stmt.setString(2, "%"+searchEbookTitle+"%");
		}
		
		// 디버깅
		System.out.println(stmt + " < EbookDao.selectEbookListAllByCategoryNameTotalPage stmt");
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			totalCount = rs.getInt("count(*)");
		}
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return totalCount;
	}
		
	// [관리자] 전자책 목록의 전체 페이지
	public int selectEbookListAllByTotalPage(String searchEbookTitle) throws ClassNotFoundException, SQLException {
		// 리턴값
		int totalCount = 0;
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement stmt = null;
		if(searchEbookTitle.equals("")== true) {
			// 쿼리문 생성
			String sql = "SELECT count(*) FROM ebook ";
			// 쿼리문 실행
			stmt = conn.prepareStatement(sql);
		}else {
			// 쿼리문 생성
			String sql = "SELECT count(*) FROM ebook WHERE ebook_title LIKE ?";
			// 쿼리문 실행
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchEbookTitle+"%");
		}
		
		// 디버깅
		System.out.println(stmt + " < EbookDao.selectEbookListAllByTotalPage stmt");
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			totalCount = rs.getInt("count(*)");
		}
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return totalCount;
	}
	
	// [관리자] 전자책 목록의 마지막 페이지
	public int selectEbookListAllByLastPage(int totalCount, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException {
		// 리턴값
		int lastPage = 0;
		// 매개변수 디버깅
		System.out.println(totalCount + "< EbookDao.selectEbookListAllByLastPage param : totalCount");
		System.out.println(ROW_PER_PAGE + "< EbookDao.selectEbookListAllByLastPage param : ROW_PER_PAGE");
		// 마지막 페이지
		// lastPage를 전체 행의 수와 한 페이지에 보여질 행의 수(rowPerPage)를 이용하여 구한다
		lastPage = totalCount / ROW_PER_PAGE;
		if(totalCount % ROW_PER_PAGE != 0) {
			lastPage+=1;
		}
		// 디버깅
		System.out.println(lastPage + " < EbookDao.selectEbookListAllByLastPage lastPage");
		
		return lastPage;
	}
}
