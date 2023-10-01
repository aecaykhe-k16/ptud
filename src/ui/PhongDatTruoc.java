package ui;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Image;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;

import javax.swing.AbstractAction;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.KeyStroke;
import javax.swing.SwingConstants;

import bus.IDatPhongService;
import bus.IHoaDonService;
import bus.IPhongService;
import bus.implement.DatPhongImp;
import bus.implement.HoaDonImp;
import bus.implement.PhongImp;
import entities.ChiTietHoaDon;
import entities.DatPhong;
import entities.HoaDon;
import entities.NhanVien;
import entities.TaiKhoan;
import entities.TrangThaiPhongEnum;
import util.ConnectDB;
import util.Constants;
import util.Generator;
import util.MyButton;

public class PhongDatTruoc extends JFrame implements ActionListener, MouseListener {
  private JButton btnBack, btnSuDung;
  private JLabel lblNgayDatPhong, lblGioNhanPhong, lblTenKH, lblSdt, lblLoaiTV, lblTenPhong, lblLoaiPhong, lblGiaPhong,
      lblNhanVien;
  private JTextField txtNgayDatPhong, txtGioNhanPhong, txtTenKH, txtSdt, txtLoaiTV, txtTenPhong, txtLoaiPhong,
      txtGiaPhong,
      txtNhanVien;
  private JPanel pnlMainUI;
  private Cursor handleCursor;
  private Generator generator = new Generator();
  private IHoaDonService hoaDonService = new HoaDonImp();
  private IPhongService phongService = new PhongImp();
  private IDatPhongService datPhongService = new DatPhongImp();
  private DatPhong datPhong;
  private NhanVien nhanVien;
  URL url = new URL(Constants.LOGO);
  Image imageIcon = new ImageIcon(url).getImage().getScaledInstance(100, 75, Image.SCALE_SMOOTH);

  public PhongDatTruoc(DatPhong dp, NhanVien nv, TaiKhoan taiKhoan) throws MalformedURLException {
    datPhong = dp;
    nhanVien = nv;
    String gioDat = new SimpleDateFormat("HH:mm").format(dp.getGioNhanPhong());
    String ngayDat = new SimpleDateFormat("dd/MM/yyyy").format(dp.getngayDatPhong());
    try {
      ConnectDB.getInstance().connect();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    setTitle(Constants.TITLE);
    setSize(720, 260);

    setLocationRelativeTo(null);
    setResizable(false);
    setLayout(null);
    setBackground(Color.WHITE);
    handleCursor = new Cursor(Cursor.HAND_CURSOR);
    pnlMainUI = new JPanel();
    pnlMainUI.setLayout(null);
    pnlMainUI.setBounds(0, 0, 720, 260);
    pnlMainUI.setBackground(Color.WHITE);
    lblNgayDatPhong = new JLabel("Ngày đặt phòng:");
    lblNgayDatPhong.setBounds(30, 20, 200, 30);
    lblNgayDatPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtNgayDatPhong = new JTextField(ngayDat);
    txtNgayDatPhong.setBounds(200, 20, 200, 30);
    txtNgayDatPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtNgayDatPhong.setEditable(false);
    txtNgayDatPhong.setOpaque(false);
    txtNgayDatPhong.setBorder(null);
    txtNgayDatPhong.setFocusable(false);
    lblGioNhanPhong = new JLabel("Giờ nhận phòng:");
    lblGioNhanPhong.setBounds(30, 50, 200, 30);
    lblGioNhanPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtGioNhanPhong = new JTextField(gioDat);
    txtGioNhanPhong.setBounds(200, 50, 200, 30);
    txtGioNhanPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtGioNhanPhong.setEditable(false);
    txtGioNhanPhong.setOpaque(false);
    txtGioNhanPhong.setBorder(null);
    txtGioNhanPhong.setFocusable(false);
    lblTenKH = new JLabel("Tên khách hàng:");
    lblTenKH.setBounds(30, 80, 200, 30);
    lblTenKH.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtTenKH = new JTextField(dp.getKhachHang().getTenKH());
    txtTenKH.setBounds(200, 80, 200, 30);
    txtTenKH.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtTenKH.setEditable(false);
    txtTenKH.setOpaque(false);
    txtTenKH.setBorder(null);
    txtTenKH.setFocusable(false);
    lblSdt = new JLabel("Số điện thoại:");
    lblSdt.setBounds(30, 110, 200, 30);
    lblSdt.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtSdt = new JTextField(dp.getKhachHang().getSdt());
    txtSdt.setBounds(200, 110, 200, 30);
    txtSdt.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtSdt.setEditable(false);
    txtSdt.setOpaque(false);
    txtSdt.setBorder(null);
    txtSdt.setFocusable(false);
    lblLoaiTV = new JLabel("Loại thành viên:");
    lblLoaiTV.setBounds(30, 140, 200, 30);
    lblLoaiTV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtLoaiTV = new JTextField(dp.getKhachHang().getLoaiTV().getTenLoaiTV());
    txtLoaiTV.setBounds(200, 140, 200, 30);
    txtLoaiTV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtLoaiTV.setEditable(false);
    txtLoaiTV.setOpaque(false);
    txtLoaiTV.setBorder(null);
    txtLoaiTV.setFocusable(false);
    lblTenPhong = new JLabel("Tên phòng:");
    lblTenPhong.setBounds(400, 20, 200, 30);
    lblTenPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtTenPhong = new JTextField(dp.getPhong().getTenPhong());
    txtTenPhong.setBounds(530, 20, 200, 30);
    txtTenPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtTenPhong.setEditable(false);
    txtTenPhong.setOpaque(false);
    txtTenPhong.setBorder(null);
    txtTenPhong.setFocusable(false);
    lblLoaiPhong = new JLabel("Loại phòng:");
    lblLoaiPhong.setBounds(400, 50, 200, 30);
    lblLoaiPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtLoaiPhong = new JTextField(generator.convertLoaiPhongToString(dp.getPhong().getLoaiPhong()));
    txtLoaiPhong.setBounds(530, 50, 200, 30);
    txtLoaiPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtLoaiPhong.setEditable(false);
    txtLoaiPhong.setOpaque(false);
    txtLoaiPhong.setBorder(null);
    txtLoaiPhong.setFocusable(false);
    lblGiaPhong = new JLabel("Giá phòng:");
    lblGiaPhong.setBounds(400, 80, 200, 30);
    lblGiaPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtGiaPhong = new JTextField(dp.getPhong().getgiaPhong() + " VNĐ");
    txtGiaPhong.setBounds(530, 80, 200, 30);
    txtGiaPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtGiaPhong.setEditable(false);
    txtGiaPhong.setOpaque(false);
    txtGiaPhong.setBorder(null);
    txtGiaPhong.setFocusable(false);
    lblNhanVien = new JLabel("Nhân viên:");
    lblNhanVien.setBounds(400, 110, 200, 30);
    lblNhanVien.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtNhanVien = new JTextField(dp.getNhanVien().getTenNV());
    txtNhanVien.setBounds(530, 110, 200, 30);
    txtNhanVien.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtNhanVien.setEditable(false);
    txtNhanVien.setOpaque(false);
    txtNhanVien.setBorder(null);
    txtNhanVien.setFocusable(false);

    pnlMainUI.add(lblNgayDatPhong);
    pnlMainUI.add(txtNgayDatPhong);
    pnlMainUI.add(lblGioNhanPhong);
    pnlMainUI.add(txtGioNhanPhong);
    pnlMainUI.add(lblTenKH);
    pnlMainUI.add(txtTenKH);
    pnlMainUI.add(lblSdt);
    pnlMainUI.add(txtSdt);
    pnlMainUI.add(lblLoaiTV);
    pnlMainUI.add(txtLoaiTV);
    pnlMainUI.add(lblTenPhong);
    pnlMainUI.add(txtTenPhong);
    pnlMainUI.add(lblLoaiPhong);
    pnlMainUI.add(txtLoaiPhong);
    pnlMainUI.add(lblGiaPhong);
    pnlMainUI.add(txtGiaPhong);
    pnlMainUI.add(lblNhanVien);
    pnlMainUI.add(txtNhanVien);

    btnSuDung = new MyButton(10, Color.decode(Constants.BTN_MAIN_COLOR), Color.decode(Constants.BTN_MAIN_COLOR));
    btnSuDung.setBorderPainted(false);
    btnSuDung.setFocusPainted(false);
    btnSuDung.setText("Sử dụng");
    btnSuDung.setBounds(250, 180, 200, 30);
    btnSuDung.setHorizontalAlignment(SwingConstants.CENTER);

    btnSuDung.setForeground(Color.decode(Constants.MAIN_TEXT_COLOR));
    btnSuDung.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 25));
    btnSuDung.setCursor(handleCursor);
    pnlMainUI.add(btnSuDung);

    btnBack = new JButton();
    btnBack.setBounds(10, 15, 30, 30);
    btnBack.setBorder(null);
    btnBack.setBorderPainted(false);
    btnBack.setContentAreaFilled(false);
    btnBack.setFocusPainted(false);
    btnBack.setOpaque(false);
    btnBack.setCursor(handleCursor);
    pnlMainUI.add(btnBack);
    add(pnlMainUI);
    btnBack.addActionListener(this);
    btnBack.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0),
        "btnBack");
    btnBack.getActionMap().put("btnBack", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnBack.doClick();
      }
    });

    btnSuDung.addActionListener(this);
  }

  @Override
  public void actionPerformed(ActionEvent e) {

    if (e.getSource() == btnBack) {
      this.dispose();
    }

    if (e.getSource() == btnSuDung) {
      int thongbao = JOptionPane.showConfirmDialog(null, "Bắt đầu sử dụng phòng này",
          "Thông báo", JOptionPane.YES_NO_OPTION);
      if (thongbao == JOptionPane.YES_OPTION) {
        datPhongService.xoaPhongDat(datPhong.getMaDP());
        phongService.updateStatus(datPhong.getPhong().getMaPhong(),
            TrangThaiPhongEnum.HOAT_DONG.name());
        String maHoaDong = generator.tuTaoMaHoaDon(datPhong.getPhong().getMaPhong(),
            nhanVien.getMaNV());
        HoaDon hd = new HoaDon(maHoaDong, LocalDateTime.now());
        hd.setNhanVien(nhanVien);
        if (datPhong.getKhachHang() != null) {
          hd.setKhachHang(datPhong.getKhachHang());
        }
        hoaDonService.themHoaDon(hd);
        ChiTietHoaDon cthd = new ChiTietHoaDon();
        cthd.setPhong(datPhong.getPhong());
        hoaDonService.themChiTietHD(cthd, maHoaDong);
        this.dispose();
        try {
          new PhongHoatDong(txtTenPhong.getText(), datPhong.getPhong().getMaPhong(),
              nhanVien, datPhong.getKhachHang(), maHoaDong).setVisible(true);
        } catch (MalformedURLException e1) {
          e1.printStackTrace();
        }
      }
    }

  }

  @Override
  public void mouseClicked(MouseEvent arg0) {

  }

  @Override
  public void mouseEntered(MouseEvent arg0) {
  }

  @Override
  public void mouseExited(MouseEvent arg0) {
  }

  @Override
  public void mousePressed(MouseEvent arg0) {
  }

  @Override
  public void mouseReleased(MouseEvent arg0) {
  }
}
