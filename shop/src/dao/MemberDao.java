package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import commons.DBUtil;
import vo.*;

public class MemberDao {
	// 회원 상세 정보
	public Member selectMemberOne(int memberNo) throws ClassNotFoundException, SQLException {
		// 리턴값
		Member returnMember = null;
		// 매개변수 디버깅
		System.out.println(memberNo + " < MemberDao.selectMemberOne param : memberNo");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "SELECT  member_no memberNo, member_id memberId, member_level memberLevel, member_name memberName, member_age memberAge, member_gender memberGender, update_date updateDate, create_date createDate FROM member WHERE member_no=?";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, memberNo);
		// 디버깅
		System.out.println(stmt + " < MemberDao.updateMemberPwByAdmin stmt");
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			returnMember = new Member();
			returnMember.setMemberNo(rs.getInt("memberNo"));
			returnMember.setMemberId(rs.getString("memberId"));
			returnMember.setMemberLevel(rs.getInt("memberLevel"));
			returnMember.setMemberName(rs.getString("memberName"));
			returnMember.setMemberAge(rs.getInt("memberAge"));
			returnMember.setMemberGender(rs.getString("memberGender"));
			returnMember.setUpdateDate(rs.getString("updateDate"));
			returnMember.setCreatDate(rs.getString("createDate"));
			System.out.println("조회 성공");
			// 자원 해제
			stmt.close();
			conn.close();
			rs.close();
			return returnMember;
		}
		System.out.println("조회 실패");
		// 자원 해제
		stmt.close();
		conn.close();
		rs.close();
		return returnMember;
	}
	
	// [관리자] 회원 등급 수정
	public void updateMemberLevelByAdmin(Member member) throws ClassNotFoundException, SQLException {
		// 매개변수 디버깅
		System.out.println(member.getMemberNo() + " < MemberDao.updateMemberLevelByAdmin param : member.memberNo");
		System.out.println(member.getMemberLevel() + " < MemberDao.updateMemberLevelByAdmin param : member.memberLevel");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "UPDATE member SET member_level=? WHERE member_no=?";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, member.getMemberLevel());
		stmt.setInt(2, member.getMemberNo());
		// 디버깅
		System.out.println(stmt + " < MemberDao.updateMemberPwByAdmin stmt");
		int row = stmt.executeUpdate();
		if(row == 1) {
			System.out.println("비밀번호 수정되었습니다.");
		}
		//자원 해제
		conn.close();
		stmt.close();
	}
	
	// [관리자] 회원 비밀번호 수정
	public void updateMemberPwByAdmin(Member member) throws ClassNotFoundException, SQLException {
		// 매개변수 디버깅
		System.out.println(member.getMemberNo() + " < MemberDao.updateMemberPwByAdmin param : member.memberNo");
		System.out.println(member.getMemberPw() + " < MemberDao.updateMemberPwByAdmin param : member.memberPw");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "UPDATE member SET member_pw=PASSWORD(?) WHERE member_no=?";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, member.getMemberPw());
		stmt.setInt(2, member.getMemberNo());
		// 디버깅
		System.out.println(stmt + " < MemberDao.updateMemberPwByAdmin stmt");
		int row = stmt.executeUpdate();
		if(row == 1) {
			System.out.println("비밀번호 수정되었습니다.");
		} else {
			System.out.println("비밀번호 수정 실패했습니다");
		}
		//자원 해제
		conn.close();
		stmt.close();
	}
	
	// [관리자] 회원 목록에서 회원 강제탈퇴(회원의 No를 받아서 DB에서 삭제)
	public void deleteMemberByKey(int memberNo) throws ClassNotFoundException, SQLException {
		// 매개변수 디버깅
		System.out.println(memberNo + " < MemberDao.deleteMemberByKey param : memberNo");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "DELETE From member WHERE member_no=?";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, memberNo);
		// 디버깅
		System.out.println(stmt + " < MemberDao.deleteMemeberByKey stmt");
		int row = stmt.executeUpdate();
		if(row == 1) {
			System.out.println("강제 회원탈퇴되었습니다.");
		}
		//자원 해제
		conn.close();
		stmt.close();
	}
	
	// [관리자] 회원 목록의 검색 아이디 전체 페이지
	public int selectMemberListAllBySearchMemberIdTotalPage(String searchMemberId) throws ClassNotFoundException, SQLException {
		// 리턴값
		int totalCount = 0;
		// 매개변수 디버깅
		System.out.println(searchMemberId + "< MemberDao.selectMemberListAllBySearchMemberIdTotalPage param : searchMemberId");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "SELECT count(*) FROM member WHERE member_id LIKE ?";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+searchMemberId+"%");
		// 디버깅
		System.out.println(stmt + " < MemberDao.selectMemberListAllByTotalPage stmt");
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
	
	// [관리자] 회원 목록의 전체 페이지
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
		stmt.close();
		rs.close();
		
		return totalCount;
	}
	
	// [관리자] 회원 목록의 마지막 페이지
	public int selectMemberListAllByLastPage(int totalCount, int rowPerPage) throws ClassNotFoundException, SQLException {
		// 리턴값
		int lastPage = 0;
		// 매개변수 디버깅
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

	// [관리자] 회원 목록 아이디 검색 출력
	public ArrayList<Member> selectMemberListAllBySearchMemberId(int beginRow, int rowPerPage, String searchMemberId) throws ClassNotFoundException, SQLException {
		// 리턴값
		ArrayList<Member> list = new ArrayList<Member>();
		// 매개변수 디버깅
		System.out.println(beginRow + "< MemberDao.selectMemberListAllBySearchMemberId param : geginRow");
		System.out.println(rowPerPage + "< MemberDao.selectMemberListAllBySearchMemberId param : rowPerPage");
		System.out.println(searchMemberId + "< MemberDao.selectMemberListAllBySearchMemberId param : searchMemberId");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "SELECT member_no memberNo, member_id memberId, member_level memberLevel, member_name memberName, member_age memberAge, member_gender memberGender, update_date updateDate, create_date createDate FROM member WHERE member_id LIKE ? ORDER BY create_date DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+searchMemberId+"%");
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);
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
	
	// [관리자] 회원 목록 출력
	public ArrayList<Member> selectMemberListAllByPage(int beginRow, int rowPerPage) throws ClassNotFoundException, SQLException {
		// 리턴값
		ArrayList<Member> list = new ArrayList<Member>();
		// 매개변수 디버깅
		System.out.println(beginRow + "< MemberDao.selectMemberListAllByPage param : geginRow");
		System.out.println(rowPerPage + "< MemberDao.selectMemberListAllByPage param : rowPerPage");
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
