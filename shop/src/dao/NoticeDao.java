package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import commons.DBUtil;
import vo.*;

public class NoticeDao {
	// [관리자 & 회원 & 일반] 최근 공지사항 5개 출력
	public ArrayList<Notice> selectNewNoticeList() throws ClassNotFoundException, SQLException{
		// 리턴값
		ArrayList<Notice> list = new ArrayList<>();
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성, 실행
		String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, member_no memberNo, create_date createDate, update_date updateDate FROM notice ORDER BY create_date DESC LIMIT 0, 5";
		PreparedStatement stmt = conn.prepareStatement(sql);
		// 디버깅
		System.out.println(stmt + " < NoticeDao.selectNewNoticeList stmt");
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Notice notice = new Notice();
			notice.setNoticeNo(rs.getInt("noticeNo"));
			notice.setNoticeTitle(rs.getString("noticeTitle"));
			notice.setNoticeContent(rs.getString("noticeContent"));
			notice.setMemberNo(rs.getInt("memberNo"));
			notice.setCreateDate(rs.getString("createDate"));
			notice.setUpdateDate(rs.getString("updateDate"));
			list.add(notice);
         }
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return list;
	}
	
	// [관리자] 공지사항 삭제
	public void deleteNotice(int noticeNo) throws ClassNotFoundException, SQLException {
		// 매개변수 디버깅
		System.out.println(noticeNo + " < NoticeDao.deleteNotice param : noticeNo");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "DELETE FROM notice WHERE notice_no=?";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, noticeNo);
		// 디버깅
		System.out.println(stmt + " < NoticeDao.deleteNotice stmt");
		int row = stmt.executeUpdate();
		if(row == 1) {
			System.out.println("공지사항 삭제 완료");
		}
		//자원 해제
		conn.close();
		stmt.close();
	}
	
	// [관리자] 공지사항 수정
	public void updateNotice(Notice notice) throws ClassNotFoundException, SQLException {
		// 매개변수 디버깅
		System.out.println(notice.getNoticeNo() + " < NoticeDao.updateNotice param : noticeNo");
		System.out.println(notice.getNoticeTitle() + " < NoticeDao.updateNotice param : noticeTitle");
		System.out.println(notice.getNoticeContent() + " < NoticeDao.updateNotice param : noticeContent");
		// DB연결 메서드 호출  
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성, 실행
		String sql="UPDATE notice SET notice_title=?, notice_content=?, update_date=Now() WHERE notice_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, notice.getNoticeTitle());
		stmt.setString(2, notice.getNoticeContent());
		stmt.setInt(3, notice.getNoticeNo());
		// 디버깅
		System.out.println(stmt + "< NoticeDao.updateNotice stmt");
		stmt.executeUpdate();
		//자원 해제
		conn.close();
		stmt.close();
	}
	
	// [관리자 & 회원 & 일반] 공지사항 상세보기
	public Notice selectNoticeOne(int noticeNo) throws ClassNotFoundException, SQLException {
		// 리턴값
		Notice notice = null;
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 실행
		String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, member_no memberNo, create_date createDate, update_date updateDate  FROM notice WHERE notice_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, noticeNo);
		System.out.println(stmt+ "< NoticeDao.selectNoticeOne stmt");
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			notice = new Notice();
			notice.setNoticeNo(rs.getInt("noticeNo"));
			notice.setNoticeTitle(rs.getString("noticeTitle"));
			notice.setNoticeContent(rs.getString("noticeContent"));
			notice.setMemberNo(rs.getInt("memberNo"));
			notice.setCreateDate(rs.getString("createDate"));
			notice.setUpdateDate(rs.getString("updateDate"));
		}
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return notice;
	}
	
	// [관리자] 공지사항 추가
	public void insertNotice(Notice notice) throws ClassNotFoundException, SQLException {
		// 매개변수 디버깅
		System.out.println(notice.getNoticeTitle() + " < NoticeDao.insertNotice param : noticeTitle");
		System.out.println(notice.getNoticeContent() + " < NoticeDao.insertNotice param : noticeContent");
		System.out.println(notice.getMemberNo() + " < NoticeDao.insertNotice param : memberNo");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "INSERT INTO notice(notice_title, notice_content, member_no, create_date, update_date) VALUES(?,?,?,Now(),Now())";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, notice.getNoticeTitle());
		stmt.setString(2, notice.getNoticeContent());
		stmt.setInt(3, notice.getMemberNo());
		// 디버깅
		System.out.println(stmt + " < NoticeDao.insertNotice stmt");
		int row = stmt.executeUpdate();
		if(row == 1) {
			System.out.println("공지사항 작성 성공");
			// 자원 해제
			stmt.close();
			conn.close();
			return;
		}
		System.out.println("공지사항 작성 실패");
		// 자원 해제
		stmt.close();
		conn.close();
	}
	
	// [관리자 & 회원 & 일반] 공지게시판의 마지막 페이지
	public int selectNoticeListAllByLastPage(int totalCount, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException {
		// 리턴값
		int lastPage = 0;
		// 매개변수 디버깅
		System.out.println(totalCount + "< NoticeDao.selectNoticeListAllByLastPage param : totalCount");
		System.out.println(ROW_PER_PAGE + "< NoticeDao.selectNoticeListAllByLastPage param : ROW_PER_PAGE");
		// 마지막 페이지
		// lastPage를 전체 행의 수와 한 페이지에 보여질 행의 수(rowPerPage)를 이용하여 구한다
		lastPage = totalCount / ROW_PER_PAGE;
		if(totalCount % ROW_PER_PAGE != 0) {
			lastPage+=1;
		}
		// 디버깅
		System.out.println(lastPage + " < NoticeDao.selectEbookListAllByLastPage lastPage");
		return lastPage;
	}
	
	// [관리자 & 회원 & 일반] 검색 공지게시판 전체 페이지
	public int selectNoticeListAllBySearchTotalPage(String searchNoticeTitle) throws ClassNotFoundException, SQLException {
		// 리턴값
		int totalCount = 0;
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "SELECT count(*) FROM notice WHERE notice_title LIKE ?";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+searchNoticeTitle+"%");
		// 디버깅
		System.out.println(stmt + " < NoticeDao.selectNoticeListAllByTotalPage stmt");
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
	
	// [관리자 & 회원 & 일반] 전체 공지게시판 전체 페이지
	public int selectNoticeListAllByTotalPage() throws ClassNotFoundException, SQLException {
		// 리턴값
		int totalCount = 0;
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "SELECT count(*) FROM notice ";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);	
		// 디버깅
		System.out.println(stmt + " < NoticeDao.selectNoticeListAllByTotalPage stmt");
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
	
	// [관리자 & 회원 & 일반] 전체 공지게시판 출력
	public ArrayList<Notice> selectNoticeList(int beginRow, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException{
		// 리턴값
		ArrayList<Notice> list = new ArrayList<>();
		// 매개변수 디버깅
		System.out.println(beginRow + "< NoticeDao.selectNoticeList param : bgeginRow");
		System.out.println(ROW_PER_PAGE + "< NoticeDao.selectNoticeList param : ROW_PER_PAGE");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 실행
		String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, member_no memberNo, create_date createDate, update_date updateDate  FROM notice ORDER BY create_date DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, ROW_PER_PAGE);
		// 디버깅
		System.out.println(stmt + " < NoticeDao.selectNoticeList stmt");
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Notice notice = new Notice();
			notice.setNoticeNo(rs.getInt("noticeNo"));
			notice.setNoticeTitle(rs.getString("noticeTitle"));
			notice.setNoticeContent(rs.getString("noticeContent"));
			notice.setMemberNo(rs.getInt("memberNo"));
			notice.setCreateDate(rs.getString("createDate"));
			notice.setUpdateDate(rs.getString("updateDate"));
			list.add(notice);
         }
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return list;
	}
	
	// [관리자 & 회원 & 일반] 검색 공지게시판 출력
	public ArrayList<Notice> selectNoticeListBySearch(int beginRow, int ROW_PER_PAGE, String searchNoticeTitle) throws ClassNotFoundException, SQLException{
		// 리턴값
		ArrayList<Notice> list = new ArrayList<>();
		// 매개변수 디버깅
		System.out.println(beginRow + "< NoticeDao.selectNoticeList param : bgeginRow");
		System.out.println(ROW_PER_PAGE + "< NoticeDao.selectNoticeList param : ROW_PER_PAGE");
		System.out.println(searchNoticeTitle + "< NoticeDao.selectNoticeList param : searchNoticeTitle");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, member_no memberNo, create_date createDate, update_date updateDate  FROM notice  WHERE notice_title LIKE ? ORDER BY create_date DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+searchNoticeTitle+"%");
		stmt.setInt(2, beginRow);
		stmt.setInt(3, ROW_PER_PAGE);
		// 디버깅
		System.out.println(stmt + " < NoticeDao.selectNoticeList stmt");
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Notice notice = new Notice();
			notice.setNoticeNo(rs.getInt("noticeNo"));
			notice.setNoticeTitle(rs.getString("noticeTitle"));
			notice.setNoticeContent(rs.getString("noticeContent"));
			notice.setMemberNo(rs.getInt("memberNo"));
			notice.setCreateDate(rs.getString("createDate"));
			notice.setUpdateDate(rs.getString("updateDate"));
			list.add(notice);
         }
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return list;
	}
}
