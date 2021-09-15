package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import commons.DBUtil;
import vo.*;

public class MemberDao {
	// 회원 목록의 전체 페이지
	public int selectMemberListAllByTotalPage() throws ClassNotFoundException, SQLException {
		// 리턴값
		int totalCount = 0;
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    // 쿼리문 생성
	    String sql = "SELECT count(*) FROM member ";
	    // 쿼리문 실행
	    PreparedStatement stmt = conn.prepareStatement(sql);
		// 디버깅
	    System.out.println(stmt + " < MemberDao.selectMemberListAllByTotalPage stmt");
	    ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			totalCount = rs.getInt("count(*)");
		}
		// 자원 해제
		conn.close();
		rs.close();
		
	    return totalCount;
	}
	
	// 회원 목록의 마지막 페이지
	public int selectMemberListAllByLastPage(int totalCount, int rowPerPage) throws ClassNotFoundException, SQLException {
		// 리턴값
		int lastPage = 0;
		System.out.println(totalCount + "< MemberDao.selectMemberListAllByLastPage param : memberId");
		System.out.println(rowPerPage + "< MemberDao.selectMemberListAllByLastPage param : memberPw");
		// 마지막 페이지
		// lastPage를 전체 행의 수와 한 페이지에 보여질 행의 수(rowPerPage)를 이용하여 구한다
		lastPage = totalCount / rowPerPage;
		if(totalCount % rowPerPage != 0) {
			lastPage+=1;
		}
		// 디버깅
		System.out.println(lastPage + " < MemberDao.selectLastPage lastPage");
		
		return lastPage;
	}

	// [관리자] 회원 목록 출력
	public ArrayList<Member> selectMemberListAllByPage(int beginRow, int rowPerPage) throws ClassNotFoundException, SQLException {
		// 리턴값
		ArrayList<Member> list = new ArrayList<Member>();
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "SELECT member_no memberNo, member_id memberId, member_level memberLevel, member_name memberName, member_age memberAge, member_gender memberGender, update_date updateDate, create_date createDate FROM member ORDER BY create_date DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		// 디버깅
		System.out.println(stmt + " < memberDao.selectMemberListAllByPaeg stmt");
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Member member = new Member();
			member.setMemberNo(rs.getInt("memberNo"));
			member.setMemberId(rs.getString("memberId"));
			member.setMemberLevel(rs.getInt("memberLevel"));
			member.setMemberName(rs.getString("memberName"));
			member.setMemberAge(rs.getInt("memberAge"));
			member.setMemberGender(rs.getString("memberGender"));
			member.setUpdateDate(rs.getString("updateDate"));
			member.setCreatDate(rs.getString("createDate"));
			list.add(member);
         }
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return list;
	}
	
	// [비회원] 회원가입
	public void insertMember(Member member) throws ClassNotFoundException, SQLException {
		// 매개변수 디버깅
		System.out.println(member.getMemberId() + "< MemberDao.insertMember param : memberId");
		System.out.println(member.getMemberPw() + "< MemberDao.insertMember param : memberPw");
		System.out.println(member.getMemberName() + "< MemberDao.insertMember param : memberName");
		System.out.println(member.getMemberAge() + "< MemberDao.insertMember param : memberAge");
		System.out.println(member.getMemberGender() + "< MemberDao.insertMember param : memberGender");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 설정
		String sql = "INSERT INTO member( member_id, member_pw, member_level, member_name, member_age, member_gender, update_date, create_date) Values(?,PASSWORD(?),0,?,?,?,NOW(),NOW())";
		// 쿼리 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, member.getMemberId());
		stmt.setString(2, member.getMemberPw());
		stmt.setString(3, member.getMemberName());
		stmt.setInt(4, member.getMemberAge());
		stmt.setString(5, member.getMemberGender());
		// 디버깅
		System.out.println(stmt + " < MemberDao.insertMember stmt");
		int row = stmt.executeUpdate();
		if(row == 1) {
			System.out.println("회원가입 성공");
			// 자원 해제
			stmt.close();
			conn.close();
			return;
		}
		// 자원 해제
		stmt.close();
		conn.close();
		System.out.println("회원가입 실패");
	}
	// [비회원] 로그인
	public Member login(Member member) throws ClassNotFoundException, SQLException {
		// 리턴값
		Member returnMember = null;
		// 매개변수 디버깅
		System.out.println(member.getMemberId() + "< MemberDao.login param : memberId");
		System.out.println(member.getMemberPw() + "< MemberDao.login param : memberPw");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 설정
		String sql = "SELECT member_no memberNo, member_id memberId, member_name memberName, member_level memberLevel FROM member WHERE member_id=? AND member_pw=PASSWORD(?)";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, member.getMemberId());
		stmt.setString(2, member.getMemberPw());
		// 디버깅
		System.out.println(stmt + " < MemberDao.login stmt");
		ResultSet rs = stmt.executeQuery();
		System.out.println(rs + " < MemberDao.login rs");
		if(rs.next()) {
			returnMember = new Member();
			returnMember.setMemberNo(rs.getInt("memberNo"));
			returnMember.setMemberId(rs.getString("memberId"));
			returnMember.setMemberName(rs.getString("memberName"));
			returnMember.setMemberLevel(rs.getInt("memberLevel"));
			System.out.println("로그인 성공");
			// 자원 해제
			stmt.close();
			conn.close();
			rs.close();
			return returnMember;
		}
		// 자원 해제
		stmt.close();
		conn.close();
		rs.close();
		System.out.println("로그인 실패");
		return null;
	}
}
