package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import vo.*;

import commons.DBUtil;

public class OrderDao {
	// 주문 입력
	public void insertOrder(Order order) throws ClassNotFoundException, SQLException {
		// 매개변수 디버깅
		System.out.println(order.getEbookNo() + "< OrderDao.insertOrder param : ebookNo");
		System.out.println(order.getMemberNo() + "< OrderDaoDao.insertOrder param : memberNo");
		System.out.println(order.getOrderPrice() + "< OrderDaoDao.insertOrder param : orderPrice");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 설정
		String sql = "INSERT INTO orders(ebook_no, member_no, order_price, create_date, update_date) VALUES(?,?,?,NOW(),NOW())";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, order.getEbookNo());
		stmt.setInt(2, order.getMemberNo());
		stmt.setInt(3, order.getOrderPrice());
		// 디버깅
		System.out.println(stmt + " < OrderDao.insertOrder stmt");
		int row = stmt.executeUpdate();
		if(row == 1) {
			System.out.println("주문 완료");
			// 자원 해제
			stmt.close();
			conn.close();
			return;
		}
		// 자원 해제
		stmt.close();
		conn.close();
		System.out.println("주문 실패");
	}
	
	// 상품 후기의 평균 별점
	public double selectOrderScoreAvg(int ebookNo) throws ClassNotFoundException, SQLException {
		// 리턴 값
		double avgScore = 0;
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "SELECT AVG(order_score) av FROM order_comment WHERE ebook_no=? GROUP BY ebook_no";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ebookNo);
		// 디버깅
		System.out.println(stmt + " < OrderDao.selectOrderScoreAvg stmt");
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			avgScore = rs.getDouble("av");
		}
		// 자원 해제
		stmt.close();
		conn.close();
		rs.close();
		return avgScore;
	}
	
	// [고객] 후기 입력
	public void insertOrderComment(OrderComment orderComment) throws ClassNotFoundException, SQLException {
		// 매개변수 디버깅
		System.out.println(orderComment.getOrderNo() + "< OrderDao.insertOrderComment param : orderNo");
		System.out.println(orderComment.getEbookNo() + "< OrderDaoDao.insertOrderComment param : ebookNo");
		System.out.println(orderComment.getOrderScore() + "< OrderDaoDao.insertOrderComment param : orderScore");
		System.out.println(orderComment.getOrderCommentContent() + "< OrderDaoDao.insertOrderComment param : orderCommentContent");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성, 이미 있는 후기인지 찾는 sql문
		String sql = "SELECT order_no FROM order_comment WHERE order_no=?";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderComment.getOrderNo());
		// 디버깅
		System.out.println(stmt + " < OrderDao.insertOrderComment stmt");
		ResultSet rs = stmt.executeQuery();
		// 이미 입력된 후기가 있는지 확인하는 if문
		if(rs.next()) {
			System.out.println("이미 입력된 후기가 존재합니다.");
			// 자원 해제
			stmt.close();
			conn.close();
			rs.close();
			return;
		}
		// 쿼리문 설정
		String sql2 = "INSERT INTO order_comment( order_no, ebook_no, order_score, order_comment_content, create_date, update_date) VALUES(?,?,?,?,NOW(),NOW())";
		// 쿼리 실행
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		stmt2.setInt(1, orderComment.getOrderNo());
		stmt2.setInt(2, orderComment.getEbookNo());
		stmt2.setInt(3, orderComment.getOrderScore());
		stmt2.setString(4, orderComment.getOrderCommentContent());
		// 디버깅
		System.out.println(stmt + " < OrderDao.insertOrderComment stmt");
		int row = stmt2.executeUpdate();
		if(row == 1) {
			System.out.println("후기 작성 완료");
			// 자원 해제
			stmt.close();
			conn.close();
			stmt2.close();
			rs.close();
			return;
		}
		// 자원 해제
		stmt.close();
		conn.close();
		stmt2.close();
		rs.close();
		System.out.println("후기 작성 실패");
	}
		
	// [고객] 주문 목록 출력
	public ArrayList<OrderEbookMember> selectOrderListByMember(int memberNo) throws ClassNotFoundException, SQLException {
		ArrayList<OrderEbookMember> list = new ArrayList<OrderEbookMember>();
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
		 * SELECT 
				o.order_no orderNo, o.order_price orderPrice, o.create_date createDate,
				e.ebook_no ebookNo, e.ebook_title ebookTitle, 
				m.member_no memberNo, m.member_id  memberId
			FROM orders o INNER JOIN ebook e INNER JOIN member m
			ON o.ebook_no = e.ebook_no AND o.member_no = m.member_no
			ORDER BY o.create_date DESC
			Limit ?, ?
		 */
		String sql = "SELECT o.order_no orderNo, o.order_price orderPrice, o.create_date createDate, e.ebook_no ebookNo, e.ebook_title ebookTitle, m.member_no memberNo, m.member_id  memberId FROM orders o INNER JOIN ebook e INNER JOIN member m ON o.ebook_no = e.ebook_no AND o.member_no = m.member_no WHERE m.member_no=? ORDER BY o.create_date DESC";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, memberNo);
		System.out.println(stmt + "< OrderDao.selectOrderList stmt");
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			OrderEbookMember oem = new OrderEbookMember();
			
			Order o = new Order();
			o.setOrderNo(rs.getInt("orderNo"));
			o.setOrderPrice(rs.getInt("orderPrice"));
			o.setCreateDate(rs.getString("createDate"));
			oem.setOrder(o);
			
			Ebook e = new Ebook();
			e.setEbookNo(rs.getInt("ebookNo"));
			e.setEbookTitle(rs.getString("ebookTitle"));
			oem.setEbook(e);
			
			Member m = new Member();
			m.setMemberNo(rs.getInt("memberNo"));
			m.setMemberId(rs.getString("memberId"));
			oem.setMember(m);
			
			list.add(oem);
		}
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		return list;
	}
	
	// [관리자] 주문 상세보기
	public OrderEbookMember selectOrderNoOne(int orderNo) throws ClassNotFoundException, SQLException {
		OrderEbookMember oem = null;
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT o.order_no orderNo, o.order_price orderPrice, o.create_date createDate, e.ebook_no ebookNo, e.ebook_title ebookTitle, e.ebook_img ebookImg, m.member_id memberId FROM orders o INNER JOIN ebook e INNER JOIN member m ON o.ebook_no = e.ebook_no AND o.member_no = m.member_no WHERE order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderNo);
		System.out.println(stmt+ "< selectOrderNoOne stmt");
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			oem = new OrderEbookMember();
	
			Order o = new Order();
			o.setOrderNo(rs.getInt("orderNo"));
			o.setOrderPrice(rs.getInt("orderPrice"));
			o.setCreateDate(rs.getString("createDate"));
			oem.setOrder(o);
			
			Ebook e = new Ebook();
			e.setEbookNo(rs.getInt("ebookNo"));
			e.setEbookTitle(rs.getString("ebookTitle"));
			e.setEbookImg(rs.getString("ebookImg"));
			oem.setEbook(e);
			
			Member m = new Member();
			m.setMemberId(rs.getString("memberId"));
			oem.setMember(m);

		}
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return oem;
	}

	// [관리자]주문 관리 목록 출력
	public ArrayList<OrderEbookMember> selectOrderList(int beginRow, int rowPerPage) throws ClassNotFoundException, SQLException {
		ArrayList<OrderEbookMember> list = new ArrayList<OrderEbookMember>();
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
		 * SELECT 
				o.order_no orderNo, o.order_price orderPrice, o.create_date createDate,
				e.ebook_no ebookNo, e.ebook_title ebookTitle, 
				m.member_no memberNo, m.member_id  memberId
			FROM orders o INNER JOIN ebook e INNER JOIN member m
			ON o.ebook_no = e.ebook_no AND o.member_no = m.member_no
			ORDER BY o.create_date DESC
			Limit ?, ?
		 */
		String sql = "SELECT o.order_no orderNo, o.order_price orderPrice, o.create_date createDate, e.ebook_no ebookNo, e.ebook_title ebookTitle, m.member_no memberNo, m.member_id  memberId FROM orders o INNER JOIN ebook e INNER JOIN member m ON o.ebook_no = e.ebook_no AND o.member_no = m.member_no ORDER BY o.create_date DESC Limit ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		System.out.println(stmt + "< OrderDao.selectOrderList stmt");
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			OrderEbookMember oem = new OrderEbookMember();
			
			Order o = new Order();
			o.setOrderNo(rs.getInt("orderNo"));
			o.setOrderPrice(rs.getInt("orderPrice"));
			o.setCreateDate(rs.getString("createDate"));
			oem.setOrder(o);
			
			Ebook e = new Ebook();
			e.setEbookNo(rs.getInt("ebookNo"));
			e.setEbookTitle(rs.getString("ebookTitle"));
			oem.setEbook(e);
			
			Member m = new Member();
			m.setMemberNo(rs.getInt("memberNo"));
			m.setMemberId(rs.getString("memberId"));
			oem.setMember(m);
			
			list.add(oem);
		}
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		return list;
	}
	
	// [관리자] 주문 목록의 전체 페이지
	public int selectOrderListAllByTotalPage() throws ClassNotFoundException, SQLException {
		// 리턴값
		int totalCount = 0;
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement stmt = null;
		// 쿼리문 생성
		String sql = "SELECT count(*) FROM orders";
		// 쿼리문 실행
		stmt = conn.prepareStatement(sql);
		
		// 디버깅
		System.out.println(stmt + " < OrderDao.selectOrderListAllByTotalPage stmt");
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
	
	// [관리자] 주문 목록의 마지막 페이지
	public int selectOrderListAllByLastPage(int totalCount, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException {
		// 리턴값
		int lastPage = 0;
		// 매개변수 디버깅
		System.out.println(totalCount + "< OrderDao.selectOrderListAllByLastPage param : totalCount");
		System.out.println(ROW_PER_PAGE + "< OrderDao.selectOrderListAllByLastPage param : ROW_PER_PAGE");
		// 마지막 페이지
		// lastPage를 전체 행의 수와 한 페이지에 보여질 행의 수(rowPerPage)를 이용하여 구한다
		lastPage = totalCount / ROW_PER_PAGE;
		if(totalCount % ROW_PER_PAGE != 0) {
			lastPage+=1;
		}
		// 디버깅
		System.out.println(lastPage + " < OrderDao.selectOrderListAllByLastPage lastPage");
		
		return lastPage;
	}
}
