package bus;

import java.util.List;

import entities.Phong;

public interface IPhongService {

  List<Phong> dsPhong();

  int validator(String chieuRong, String chieuDai, String tenTV, String tenBan, String tenPhong, String tenSofa);

  boolean themPhong(Phong phong);

  boolean xoaPhong(String maPhong);

  boolean suaPhong(Phong phong);

  List<Phong> updateStatus(String maPhong, String trangThai);

  void traPhong(String maPhong, String trangThai);

}
