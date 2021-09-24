package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import vo.*;

import commons.DBUtil;
import vo.OrderEbookMember;

public class OrderDao {
	
	// 주문 관리 목록 출력
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
	
	// 전자책 목록의 전체 페이지
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
	
	// 전자책 목록의 마지막 페이지
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
