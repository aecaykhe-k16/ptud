package ui;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Font;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

import javax.swing.AbstractAction;
import javax.swing.DefaultComboBoxModel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.KeyStroke;

import bus.IHoaDonService;
import bus.IKhachHangService;
import bus.IPhongService;
import bus.implement.HoaDonImp;
import bus.implement.KhachHangImp;
import bus.implement.PhongImp;
import entities.ChiTietHoaDon;
import entities.HoaDon;
import entities.KhachHang;
import entities.LoaiPhongEnum;
import entities.LoaiThanhVien;
import entities.NhanVien;
import entities.Phong;
import entities.TrangThaiPhongEnum;
import util.ConnectDB;
import util.Constants;
import util.Generator;
import util.PlaceholderTextField;
import util.SpecialButton;

public class ModelDangKy extends JFrame implements ActionListener {
  private JPanel pnlInfo;
  private PlaceholderTextField txtTen, txtSdt;
  private JLabel lblTen, lblSdt, lblDanhSach1, lblDanhSach2;
  private JButton btnDangKy, btnBack;
  private DefaultComboBoxModel<String> dfModelLoaiPhong, dfModelPhong;
  private JComboBox<String> cmbLoaiPhong, cmbPhong;

  private Generator generator = new Generator();
  private Cursor handleCursor;
  private IPhongService phongService = new PhongImp();
  private IHoaDonService hoaDonService = new HoaDonImp();
  private IKhachHangService khachHangService = new KhachHangImp();
  private Font fontMain = new Font(Constants.MAIN_FONT, Font.PLAIN, 20);
  URL url = new URL(Constants.LOGO);
  Image imageIcon = new ImageIcon(url).getImage().getScaledInstance(100, 75, Image.SCALE_SMOOTH);
  boolean loaiDangKy;
  private NhanVien nhanVien;
  private List<Phong> listPhongVip, listPhongThuong;
  private KhachHang khachHang;

  public ModelDangKy(List<Phong> listPhongVip, List<Phong> listPhongThuong, NhanVien nv) throws MalformedURLException {
    this.nhanVien = nv;
    this.listPhongVip = listPhongVip;
    this.listPhongThuong = listPhongThuong;
    setTitle(Constants.APP_NAME);
    setSize(400, 340);

    setLocationRelativeTo(null);
    setResizable(false);
    setIconImage(imageIcon);
    setLayout(null);
    handleCursor = new Cursor(Cursor.HAND_CURSOR);
    try {
      ConnectDB.getInstance().connect();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    pnlInfo = new JPanel();
    pnlInfo.setLayout(null);
    pnlInfo.setBounds(0, 0, 400, 340);

    pnlInfo.setBackground(Color.WHITE);
    add(pnlInfo);

    lblTen = new JLabel("Tên khách hàng");
    lblTen.setBounds(50, 10, 150, 30);
    lblTen.setFont(new Font("Arial", Font.PLAIN, 16));
    pnlInfo.add(lblTen);

    txtTen = new PlaceholderTextField(Color.GRAY, false);
    txtTen.requestFocus();
    txtTen.setPlaceholder("Nhập tên khách hàng");
    txtTen.setBounds(50, 40, 300, 30);
    txtTen.setFont(new Font("Arial", Font.PLAIN, 16));
    pnlInfo.add(txtTen);

    lblSdt = new JLabel("Số điện thoại");
    lblSdt.setBounds(50, 80, 100, 30);
    lblSdt.setFont(new Font("Arial", Font.PLAIN, 16));
    pnlInfo.add(lblSdt);

    txtSdt = new PlaceholderTextField(Color.GRAY, false);
    txtSdt.setPlaceholder("Nhập số điện thọai");
    txtSdt.setBounds(50, 110, 300, 30);
    txtSdt.setFont(new Font("Arial", Font.PLAIN, 16));
    pnlInfo.add(txtSdt);
    txtSdt.addActionListener(this);

    btnDangKy = new SpecialButton(10, Color.decode("#9dade4"), null);
    btnDangKy.setBounds(50, 260, 300, 40);
    btnDangKy.setText("Đăng ký");
    btnDangKy.setFont(new Font("Arial", Font.PLAIN, 16));
    btnDangKy.setCursor(handleCursor);
    btnDangKy.setBorderPainted(false);
    btnDangKy.setContentAreaFilled(false);
    btnDangKy.setFocusPainted(false);
    btnDangKy.addActionListener(this);
    pnlInfo.add(btnDangKy);

    dfModelLoaiPhong = new DefaultComboBoxModel<String>();
    dfModelLoaiPhong.addElement("Chọn loại phòng");
    for (LoaiPhongEnum t : LoaiPhongEnum.values()) {
      dfModelLoaiPhong.addElement(t.getLoaiPhong());
    }
    cmbLoaiPhong = new JComboBox<String>(dfModelLoaiPhong);
    cmbLoaiPhong.setFont(fontMain);
    cmbLoaiPhong.setBorder(null);
    cmbLoaiPhong.setBounds(30, 160, 180, 30);
    cmbLoaiPhong.setBackground(Color.decode(Constants.INPUT_COLOR));

    dfModelPhong = new DefaultComboBoxModel<String>();
    dfModelPhong.addElement("Chọn phòng");

    listPhongThuong.forEach((phong) -> {
      dfModelPhong.addElement(phong.getTenPhong().trim());
    });

    int count = dfModelPhong.getSize();
    if (count == 0) {
      dfModelPhong.removeAllElements();
      dfModelPhong.addElement("Hết phòng");
    }
    dfModelPhong.setSelectedItem(dfModelPhong.getElementAt(0));
    cmbPhong = new JComboBox<String>(dfModelPhong);
    cmbPhong.setFont(fontMain);
    cmbPhong.setBounds(220, 160, 150, 30);
    cmbPhong.setBackground(Color.decode(Constants.INPUT_COLOR));
    cmbPhong.setEnabled(false);

    lblDanhSach1 = new JLabel();
    lblDanhSach1.setBounds(30, 200, 300, 30);
    lblDanhSach1.setFont(new Font("Arial", Font.PLAIN, 16));
    pnlInfo.add(lblDanhSach1);
    lblDanhSach2 = new JLabel();
    lblDanhSach2.setBounds(30, 230, 300, 30);
    lblDanhSach2.setFont(new Font("Arial", Font.PLAIN, 16));
    pnlInfo.add(lblDanhSach2);

    pnlInfo.add(cmbLoaiPhong);
    pnlInfo.add(cmbPhong);
    cmbLoaiPhong.addActionListener(this);
    cmbPhong.addActionListener(this);

    btnBack = new JButton();
    btnBack.setBorder(null);
    btnBack.setBorderPainted(false);
    btnBack.setContentAreaFilled(false);
    btnBack.setFocusPainted(false);
    btnBack.setOpaque(false);
    btnBack.setCursor(handleCursor);
    pnlInfo.add(btnBack);
    btnBack.addActionListener(this);
    btnBack.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0),
        "btnBack");
    btnBack.getActionMap().put("btnBack", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnBack.doClick();
      }
    });
  }

  @Override
  public void actionPerformed(ActionEvent e) {

    if (e.getSource() == btnDangKy) {
      String ten = txtTen.getText();
      String sdt = txtSdt.getText();
      if (ten.equals("") || sdt.equals("")) {
        JOptionPane.showMessageDialog(null, "Vui lòng nhập đầy đủ thông tin");
      } else if (sdt.matches("[0-9]+") == false) {
        JOptionPane.showMessageDialog(null, "Số điện thoại không hợp lệ");
      } else {
        String ma = sdt.substring(6, 10);
        KhachHang kh = new KhachHang(ma, ten, sdt, true);
        LoaiThanhVien ltv = new LoaiThanhVien();
        String maloaitv = generator.random3SoNguyen() + generator.random4SoNguyen() + "";
        ltv.setMaLoaiTV(maloaitv);
        kh.setLoaiTV(ltv);
        String[] danhSach = lblDanhSach1.getText().concat(lblDanhSach2.getText()).split(", ");
        if (khachHang != null) {
          for (String string : danhSach) {
            for (Phong p : phongService.dsPhong()) {
              if (p.getTenPhong().trim().equals(string)) {
                String maHoaDon = generator.tuTaoMaHoaDon(p.getMaPhong(),
                    nhanVien.getMaNV());
                HoaDon hd = new HoaDon(maHoaDon, LocalDateTime.now());
                hd.setKhachHang(khachHang);
                hd.setNhanVien(nhanVien);
                hoaDonService.themHoaDon(hd);
                ChiTietHoaDon cthd = new ChiTietHoaDon();
                cthd.setPhong(p);
                hoaDonService.themChiTietHD(cthd, maHoaDon);
                phongService.updateStatus(p.getMaPhong(),
                    TrangThaiPhongEnum.HOAT_DONG.name());
                JOptionPane.showMessageDialog(null, "Đặt phòng thành công");
                this.dispose();
                break;
              }
            }
          }
        } else {
          if (khachHangService.themKhachHang(kh)) {
            for (String string : danhSach) {
              for (Phong p : phongService.dsPhong()) {
                if (p.getTenPhong().trim().equals(string)) {
                  String maHoaDon = generator.tuTaoMaHoaDon(p.getMaPhong(),
                      nhanVien.getMaNV());
                  HoaDon hd = new HoaDon(maHoaDon, LocalDateTime.now());
                  hd.setKhachHang(kh);
                  hd.setNhanVien(nhanVien);
                  hoaDonService.themHoaDon(hd);
                  ChiTietHoaDon cthd = new ChiTietHoaDon();
                  cthd.setPhong(p);
                  hoaDonService.themChiTietHD(cthd, maHoaDon);
                  phongService.updateStatus(p.getMaPhong(),
                      TrangThaiPhongEnum.HOAT_DONG.name());
                }
              }
            }
            JOptionPane.showMessageDialog(null, "Đặt phòng thành công");
            this.dispose();
          } else {
            JOptionPane.showMessageDialog(null, "Đặt phòng thất bại");
          }
        }
      }
    } else if (e.getSource() == btnBack) {
      this.dispose();
    } else if (e.getSource() == cmbLoaiPhong) {
      String value = cmbLoaiPhong.getSelectedItem().toString();
      if (value.equals("VIP")) {
        cmbPhong.setEnabled(true);
        dfModelPhong.removeAllElements();
        dfModelPhong.addElement("Chọn phòng");
        for (Phong phong : listPhongVip) {
          dfModelPhong.addElement(phong.getTenPhong().trim());
        }
        int count = dfModelPhong.getSize();
        if (count == 0) {
          dfModelPhong.addElement("Hêt phòng");
        }

      } else if (value.startsWith("T")) {
        cmbPhong.setEnabled(true);

        dfModelPhong.removeAllElements();
        dfModelPhong.addElement("Chọn phòng");

        for (Phong phong : listPhongThuong) {
          dfModelPhong.addElement(phong.getTenPhong().trim());
        }
        int count = dfModelPhong.getSize();
        if (count == 0) {
          dfModelPhong.addElement("Hêt phòng");
        }
      }
    } else if (e.getSource() == cmbPhong) {
      if (cmbPhong.getSelectedIndex() > 0) {
        String value = cmbPhong.getSelectedItem().toString();
        dfModelPhong.removeElement(value);
        String[] arr = lblDanhSach1.getText().split(", ");
        if (arr.length == 3) {
          lblDanhSach2.setText(lblDanhSach2.getText().concat(value + ", "));
        } else
          lblDanhSach1.setText(lblDanhSach1.getText().concat(value + ", "));
      }
    } else if (e.getSource() == txtSdt) {
      String sdt = txtSdt.getText();
      if (!sdt.matches("\\d{10}+")) {
        JOptionPane.showMessageDialog(null, "Số điện thoại không hợp lệ", "Cảnh báo",
            JOptionPane.ERROR_MESSAGE);
        txtSdt.requestFocus();
        return;
      } else {
        khachHang = khachHangService.timKhachHang(sdt);
        txtTen.setText(khachHang.getTenKH());
      }
    }
  }

}
