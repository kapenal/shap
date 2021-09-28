package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import commons.DBUtil;

public class OrderCommentDao {
	// 후기 중복 방지
	public int orderCommentCheck(int orderNo) throws ClassNotFoundException, SQLException {
		// 리턴값
		int exist = 0;
		// 매개변수 디버깅
		System.out.println(orderNo + "< OrderCommentDao.orderCommentCheck param : orderNo");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성, 이미 있는 후기인지 찾는 sql문
		String sql = "SELECT order_no FROM order_comment WHERE order_no=?";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderNo);
		// 디버깅
		System.out.println(stmt + " < OrderDao.insertOrderComment stmt");
		ResultSet rs = stmt.executeQuery();
		// 이미 입력된 후기가 있는지 확인하는 if문
		if(rs.next()) {
			exist = 1;
		}
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		return exist;
	}
	
	// 전제 후기 페이지 수
	public int selectOrderCommentTotalPage(int ebookNo) throws ClassNotFoundException, SQLException {
		int totalCount = 0;
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM order_comment WHERE ebook_no=?");
		stmt.setInt(1, ebookNo);
		System.out.println("stmt의 값 :" + stmt);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			totalCount = rs.getInt("count(*)");
			System.out.println(totalCount);
		}
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		return totalCount;
	}
	// 후기 마지막 페이지
	public int selectCommentLastPage(int orderCommentCount,  int orderCommentRowPerPage) throws ClassNotFoundException, SQLException {
		// lastPage를 전체 행의 수와 한 페이지에 보여질 행의 수(rowPerPage)를 이용하여 구한다
		int lastPage = orderCommentCount / orderCommentRowPerPage;
		System.out.println(lastPage + "라스트페이지갯수");
		System.out.println(orderCommentCount + "토탈페이지갯수");
		System.out.println(orderCommentRowPerPage + "rowPerPage페이지갯수");
		if(orderCommentCount % orderCommentRowPerPage != 0) {
			lastPage+=1;
		}
		// 디버깅
		System.out.println("lastPage : "+lastPage);
		// 화면에 보여질 페이지 번호의 갯수
		return lastPage;
	}
}
