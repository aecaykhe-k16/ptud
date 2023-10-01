package ui;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Cursor;
import java.awt.Desktop;
import java.awt.Font;
import java.awt.Frame;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.List;

import javax.swing.AbstractAction;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JLayeredPane;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.KeyStroke;
import javax.swing.Timer;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;

import org.kordamp.ikonli.fontawesome5.FontAwesomeSolid;
import org.kordamp.ikonli.swing.FontIcon;

import com.github.lgooddatepicker.components.DatePickerSettings;
import com.toedter.calendar.JDateChooser;

import bus.IDangNhapService;
import bus.IHoaDonService;
import bus.IPhanCongCaLamService;
import bus.implement.DangNhapImp;
import bus.implement.HoaDonImp;
import bus.implement.PhanCongCaLamImp;
import entities.ChiTietDichVu;
import entities.ChiTietHoaDon;
import entities.HoaDon;
import entities.TaiKhoan;
import util.ConnectDB;
import util.Constants;
import util.MyButton;
import util.PlaceholderTextField;
import util.SpecialButton;

public class HoaDonUi extends JFrame implements ActionListener {
  private JPanel pnlMainUI, pnlCenter, pnlMenu, pnlTop, pnInfo;
  private JTable tblHoaDon;
  private DefaultTableModel tableModelHD;
  private JButton btnHoaDon;
  private JLabel lblIconLogo, lblTitle, lblHoaDon, lblDanhSachCaLam, lblTenBang;
  private JButton btnIconLogout, btnIconUser, btnTimHD, btnRefreshDV;
  private Cursor handCursor = new Cursor(Cursor.HAND_CURSOR);
  private IHoaDonService hoaDonService = new HoaDonImp();
  private PlaceholderTextField txtTimKiemSDT;

  private JButton btnNhanVien, btnPhong, btnKhachHang, btnThongke, btnPhanCong, btnTroGiup, btnQuanLyDatPhong,
      btnDichVu;
  private JLabel lblNhanVien, lblPhong, lblKhachHang, lblThongke, lblPhanCong, lbLTimNgayLapHD,
      lblQuanLyDatPhong, lblDichVu;
  private JLayeredPane layeredPane;
  private IDangNhapService dangNhap = new DangNhapImp();
  private TaiKhoan tk;
  private JDateChooser txtNgayLapHoaDon;
  private DatePickerSettings dateSettings;
  private IPhanCongCaLamService caLamService = new PhanCongCaLamImp();
  URL url = new URL(Constants.LOGO);
  Image imageIcon = new ImageIcon(url).getImage().getScaledInstance(100, 75, Image.SCALE_SMOOTH);
  Calendar calendar = Calendar.getInstance();

  public HoaDonUi(TaiKhoan taiKhoan) throws MalformedURLException {
    try {
      ConnectDB.getInstance().connect();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    tk = taiKhoan;

    setTitle(Constants.APP_NAME);
    setSize(1450, 700);
    setLocationRelativeTo(null);
    setDefaultCloseOperation(EXIT_ON_CLOSE);
    this.setIconImage(imageIcon);
    setLocationRelativeTo(null);
    this.setBackground(Color.WHITE);
    setLayout(null);
    layeredPane = new JLayeredPane();
    layeredPane.setBounds(0, 0, 1450, 1500);
    add(layeredPane);
    MainUI();
    dateSettings = new DatePickerSettings();
    dateSettings.setFormatForDatesCommonEra("dd/MM/yyyy");
    dateSettings.setAllowKeyboardEditing(false);
    dateSettings.setFirstDayOfWeek(DayOfWeek.MONDAY);
    btnTimHD.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_ENTER, 0),
        "btnTimHD");
    btnTimHD.getActionMap().put("btnTimHD", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnTimHD.doClick();
      }
    });
  }

  private void MainUI() {
    pnlMainUI = new JPanel();
    pnlMainUI.setLayout(null);
    pnlMainUI.setBounds(0, 0, 1450, 1400);
    PnlTop();
    PnlMenu();
    PnlCenter();
    PnlTable();
    layeredPane.add(pnlMainUI, Integer.valueOf(1));
    btnTimHD.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F1, 0),
        "btnTimHD");
    btnTimHD.getActionMap().put("btnTimHD", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnTimHD.doClick();
      }
    });
  }

  void PnlMenu() {
    try {
      URL lineURL = new URL(Constants.ICON_LINE);
      Image line = new ImageIcon(lineURL).getImage().getScaledInstance(10, 40, Image.SCALE_SMOOTH);
      pnlMenu = new JPanel();
      pnlMenu.setBounds(0, 100, 1800, 50);
      pnlMenu.setLayout(null);
      pnlMenu.setBackground(Color.decode(Constants.MAIN_COLOR));
      Font f2 = new Font(Constants.MAIN_FONT, 0, 17);
      lblNhanVien = new JLabel(new ImageIcon(line));
      lblNhanVien.setBounds(160, 0, 10, 50);

      btnNhanVien = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnNhanVien.setText("Nhân viên");
      btnNhanVien.setFont(f2);
      btnNhanVien.setBounds(0, 0, 160, 50);
      btnNhanVien.setBorder(null);
      btnNhanVien.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnNhanVien.setCursor(handCursor);
      btnNhanVien.setIcon(FontIcon.of(FontAwesomeSolid.USERS, 30));
      btnNhanVien.setFocusPainted(false);

      lblPhong = new JLabel(new ImageIcon(line));
      lblPhong.setBounds(320, 0, 10, 50);

      btnPhong = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnPhong.setText("Phòng");
      btnPhong.setFont(f2);
      btnPhong.setBounds(160, 0, 160, 50);
      btnPhong.setBorder(null);
      btnPhong.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnPhong.setCursor(handCursor);
      btnPhong.setIcon(FontIcon.of(FontAwesomeSolid.DOOR_CLOSED, 30));
      btnPhong.setFocusPainted(false);

      lblKhachHang = new JLabel(new ImageIcon(line));
      lblKhachHang.setBounds(480, 0, 10, 50);

      btnKhachHang = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnKhachHang.setText("Khách hàng");
      btnKhachHang.setFont(f2);
      btnKhachHang.setBounds(320, 0, 160, 50);
      btnKhachHang.setBorder(null);
      btnKhachHang.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnKhachHang.setCursor(handCursor);
      btnKhachHang.setIcon(FontIcon.of(FontAwesomeSolid.USER_TIE, 30));
      btnKhachHang.setFocusPainted(false);

      lblHoaDon = new JLabel(new ImageIcon(line));
      lblHoaDon.setBounds(640, 0, 10, 50);

      btnHoaDon = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnHoaDon.setText("Hóa đơn");
      btnHoaDon.setFont(f2);
      btnHoaDon.setBounds(480, 0, 160, 50);
      btnHoaDon.setBorder(null);
      btnHoaDon.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnHoaDon.setCursor(handCursor);
      btnHoaDon.setIcon(FontIcon.of(FontAwesomeSolid.RECEIPT, 30, Color.decode("#7743DB")));
      btnHoaDon.setFocusPainted(false);

      lblThongke = new JLabel(new ImageIcon(line));
      lblThongke.setBounds(800, 0, 10, 50);

      btnThongke = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnThongke.setText("Thống kê");
      btnThongke.setFont(f2);
      btnThongke.setBounds(640, 0, 160, 50);
      btnThongke.setBorder(null);
      btnThongke.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnThongke.setCursor(handCursor);
      btnThongke.setIcon(FontIcon.of(FontAwesomeSolid.CHART_BAR, 30));
      btnThongke.setFocusPainted(false);

      lblPhanCong = new JLabel(new ImageIcon(line));
      lblPhanCong.setBounds(960, 0, 10, 50);

      btnPhanCong = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnPhanCong.setText("Phân công");
      btnPhanCong.setFont(f2);
      btnPhanCong.setBounds(800, 0, 160, 50);
      btnPhanCong.setBorder(null);
      btnPhanCong.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnPhanCong.setCursor(handCursor);
      btnPhanCong.setIcon(FontIcon.of(FontAwesomeSolid.TASKS, 30));
      btnPhanCong.setFocusPainted(false);

      lblQuanLyDatPhong = new JLabel(new ImageIcon(line));
      lblQuanLyDatPhong.setBounds(1120, 0, 10, 50);

      btnQuanLyDatPhong = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnQuanLyDatPhong.setText("Đặt phòng");
      btnQuanLyDatPhong.setFont(f2);
      btnQuanLyDatPhong.setBounds(960, 0, 160, 50);
      btnQuanLyDatPhong.setBorder(null);
      btnQuanLyDatPhong.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnQuanLyDatPhong.setCursor(handCursor);
      btnQuanLyDatPhong.setIcon(FontIcon.of(FontAwesomeSolid.TH, 30));
      btnQuanLyDatPhong.setFocusPainted(false);

      lblDichVu = new JLabel(new ImageIcon(line));
      lblDichVu.setBounds(1280, 0, 10, 50);

      btnDichVu = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnDichVu.setText("Dịch vụ");
      btnDichVu.setFont(f2);
      btnDichVu.setBounds(1120, 0, 160, 50);
      btnDichVu.setBorder(null);
      btnDichVu.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnDichVu.setCursor(handCursor);
      btnDichVu.setIcon(FontIcon.of(FontAwesomeSolid.CONCIERGE_BELL, 30));
      btnDichVu.setFocusPainted(false);

      btnTroGiup = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnTroGiup.setText("Trợ giúp");
      btnTroGiup.setFont(f2);
      btnTroGiup.setBounds(1280, 0, 160, 50);
      btnTroGiup.setBorder(null);
      btnTroGiup.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnTroGiup.setCursor(handCursor);
      btnTroGiup.setIcon(FontIcon.of(FontAwesomeSolid.QUESTION_CIRCLE, 30));
    } catch (Exception e) {
      e.printStackTrace();
    }
    if (dangNhap.getNV(tk.getEmail()).getQuanLy() == null) {
      lblKhachHang.setBounds(160, 0, 10, 50);
      btnKhachHang.setBounds(0, 0, 160, 50);
      lblHoaDon.setBounds(320, 0, 10, 50);
      btnHoaDon.setBounds(160, 0, 160, 50);
      lblThongke.setBounds(480, 0, 10, 50);
      btnThongke.setBounds(320, 0, 160, 50);
      lblQuanLyDatPhong.setBounds(640, 0, 10, 50);
      btnQuanLyDatPhong.setBounds(480, 0, 160, 50);
      lblDichVu.setBounds(800, 0, 10, 50);
      btnDichVu.setBounds(640, 0, 160, 50);
      btnTroGiup.setBounds(800, 0, 160, 50);
      pnlMenu.add(lblKhachHang);
      pnlMenu.add(btnKhachHang);
      pnlMenu.add(lblHoaDon);
      pnlMenu.add(btnHoaDon);
      pnlMenu.add(lblThongke);
      pnlMenu.add(btnThongke);

      pnlMenu.add(lblQuanLyDatPhong);
      pnlMenu.add(btnQuanLyDatPhong);
      pnlMenu.add(lblDichVu);
      pnlMenu.add(btnDichVu);
      pnlMenu.add(btnTroGiup);
      btnKhachHang.addActionListener(this);
      btnHoaDon.addActionListener(this);
      btnThongke.addActionListener(this);
      btnQuanLyDatPhong.addActionListener(this);
      btnDichVu.addActionListener(this);
      btnTroGiup.addActionListener(this);
    } else {
      pnlMenu.add(lblNhanVien);
      pnlMenu.add(btnNhanVien);
      pnlMenu.add(lblPhong);
      pnlMenu.add(btnPhong);
      pnlMenu.add(lblKhachHang);
      pnlMenu.add(btnKhachHang);
      pnlMenu.add(lblHoaDon);
      pnlMenu.add(btnHoaDon);
      pnlMenu.add(lblThongke);
      pnlMenu.add(btnThongke);
      pnlMenu.add(lblPhanCong);
      pnlMenu.add(btnPhanCong);
      pnlMenu.add(lblQuanLyDatPhong);
      pnlMenu.add(btnQuanLyDatPhong);
      pnlMenu.add(lblDichVu);
      pnlMenu.add(btnDichVu);
      pnlMenu.add(btnTroGiup);
      btnNhanVien.addActionListener(this);
      btnPhong.addActionListener(this);
      btnKhachHang.addActionListener(this);
      btnHoaDon.addActionListener(this);
      btnThongke.addActionListener(this);
      btnPhanCong.addActionListener(this);
      btnQuanLyDatPhong.addActionListener(this);
      btnDichVu.addActionListener(this);
      btnTroGiup.addActionListener(this);
    }

    pnlMainUI.add(pnlMenu);

  }

  void PnlTop() {
    pnlTop = new JPanel();
    pnlTop.setBounds(0, 0, 1450, 100);

    pnlTop.setBackground(Color.decode(Constants.TITLE_COLOR));

    pnlTop.setLayout(null);

    lblIconLogo = new JLabel();
    lblIconLogo.setBounds(50, 0, 150, 100);
    lblIconLogo.setIcon(new ImageIcon(imageIcon));

    lblTitle = new JLabel(Constants.TITLE);
    lblTitle.setBounds(400, 0, 750, 100);
    lblTitle.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 60));
    lblTitle.setForeground(Color.decode("#FFFFFFF"));

    pnInfo = new JPanel();
    pnInfo.setBounds(1200, 0, 250, 100);
    pnInfo.setBackground(Color.decode(Constants.TITLE_COLOR));
    pnInfo.setLayout(null);

    btnIconUser = new SpecialButton(0, Color.decode(Constants.TITLE_COLOR), Color.decode(Constants.TITLE_COLOR));
    btnIconUser.setText(dangNhap.getNV(tk.getEmail()).getTenNV());
    btnIconUser.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 16));
    btnIconUser.setBounds(0, 0, 250, 50);
    btnIconUser.setBorder(null);
    btnIconUser.setForeground(Color.WHITE);
    btnIconUser.setIcon(FontIcon.of(FontAwesomeSolid.USER, 30, Color.WHITE));
    btnIconUser.setBorderPainted(false);
    btnIconUser.setFocusPainted(false);

    btnIconLogout = new SpecialButton(0, Color.decode(Constants.TITLE_COLOR), Color.decode(Constants.TITLE_COLOR));
    btnIconLogout.setText(Constants.DANG_XUAT);
    btnIconLogout.setBounds(30, 50, 200, 50);
    btnIconLogout.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 16));
    btnIconLogout.setBorder(null);
    btnIconLogout.setForeground(Color.WHITE);
    btnIconLogout.setIcon(FontIcon.of(FontAwesomeSolid.SIGN_OUT_ALT, 30, Color.RED));
    btnIconLogout.setBorderPainted(false);
    btnIconLogout.setFocusPainted(false);

    btnIconUser.setCursor(handCursor);
    btnIconLogout.setCursor(handCursor);

    lblDanhSachCaLam = new JLabel(caLamService.getCaTucTheoNV(tk.getEmail()));
    lblDanhSachCaLam.setBounds(1000, 70, 600, 20);
    lblDanhSachCaLam.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    lblDanhSachCaLam.setForeground(Color.decode("#FFFFFFF"));
    Timer t = new Timer(500, this); // set a timer
    t.setInitialDelay(0);
    t.start();
    pnlTop.add(lblDanhSachCaLam);

    pnInfo.add(btnIconUser);
    pnInfo.add(btnIconLogout);

    pnlTop.add(lblIconLogo);
    pnlTop.add(lblTitle);
    pnlTop.add(pnInfo);
    pnlMainUI.add(pnlTop);
    btnIconUser.addActionListener(this);
    btnIconLogout.addActionListener(this);
  }

  void PnlTable() {
    JPanel pnBang = new JPanel();
    pnBang.setLayout(new BorderLayout());

    String[] header = { "Mã hoá đơn", "Ngày lập", "Tên Phòng", "Giá Phòng", "Giờ sử dụng", "Tên dịch vụ",
        "Giá dịch vụ", "Số lượng", "Tên KH", "Tên NV" };

    tableModelHD = new DefaultTableModel(header, 0);

    tblHoaDon = new JTable(tableModelHD);
    tblHoaDon.setRowHeight(25);
    tblHoaDon.getColumnModel().getColumn(0).setMinWidth(200);
    tblHoaDon.getColumnModel().getColumn(0).setMaxWidth(200);
    tblHoaDon.getColumnModel().getColumn(0).setWidth(200);
    tblHoaDon.getColumnModel().getColumn(7).setMinWidth(100);
    tblHoaDon.getColumnModel().getColumn(7).setMaxWidth(100);
    JScrollPane scrollPane = new JScrollPane(tblHoaDon);
    tblHoaDon.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 15));
    tblHoaDon.setRowHeight(20);
    tblHoaDon.getTableHeader().setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 15));
    pnBang.add(scrollPane);
    pnBang.setBounds(15, 270, 1400, 360);
    tblHoaDon.setDefaultEditor(Object.class, null);
    DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
    centerRenderer.setHorizontalAlignment(JLabel.CENTER);
    for (int x = 0; x < 4; x++) {
      tblHoaDon.getColumnModel().getColumn(x).setCellRenderer(centerRenderer);
    }
    loadTable();
    pnlMainUI.add(pnBang);
  }

  void PnlCenter() {
    lblTenBang = new JLabel("Danh sách hoá đơn:");
    lblTenBang.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    lblTenBang.setBounds(40, 235, 200, 30);
    lblTenBang.setForeground(Color.decode(Constants.MENU_TITLE_COLOR));
    pnlMainUI.add(lblTenBang);

    pnlCenter = new JPanel();
    pnlCenter.setBounds(40, 180, 1300, 60);
    pnlCenter.setLayout(null);

    lbLTimNgayLapHD = new JLabel("Ngày lập Hoá Đơn : ");
    lbLTimNgayLapHD.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 18));
    lbLTimNgayLapHD.setBounds(0, 10, 180, 35);
    lbLTimNgayLapHD.setBackground(Color.red);

    txtNgayLapHoaDon = new JDateChooser();
    txtNgayLapHoaDon.setBounds(200, 10, 200, 30);
    txtNgayLapHoaDon.setFont(new Font("Arial", Font.ITALIC, 18));
    txtNgayLapHoaDon.setCursor(new Cursor(Cursor.HAND_CURSOR));
    txtNgayLapHoaDon.setDateFormatString("dd/MM/yyyy");
    // add listener for txtngaLapHoaDon
    txtNgayLapHoaDon.getDateEditor().addPropertyChangeListener(new PropertyChangeListener() {
      @Override
      public void propertyChange(PropertyChangeEvent evt) {
        if ("date".equals(evt.getPropertyName())) {
          loadTable();
          // tìm hoá đơn
          if (txtNgayLapHoaDon.getDate() == null) {
            JOptionPane.showMessageDialog(null, "Bạn vui lòng nhập định dạng ngày tháng ");
            return;
          }
          calendar.setTime(txtNgayLapHoaDon.getDate());
          // lấy ngày
          String day = layNgayhoadon(calendar.get(Calendar.DAY_OF_MONTH));
          // lấy tháng
          String month = laythanghoadon(calendar.get(Calendar.MONTH) + 1);
          // lấy năm
          String year = String.valueOf(calendar.get(Calendar.YEAR));
          String tenHDTim = day + "/" + month + "/" + year;
          String checkdate = "^(0[1-9]|[12][0-9]|[3][01])/(0[1-9]|1[012])/\\d{4}$";
          Boolean check = false;

          if (!tenHDTim.matches(checkdate)) {
            JOptionPane.showMessageDialog(null, "Bạn phải nhập đúng định dạng DD/MM/YYYY");
            return;
          } else {
            for (int i = 0; i < tableModelHD.getRowCount(); i++) {
              Boolean result = false;
              String tenHD = tableModelHD.getValueAt(i, 1).toString();
              if (tenHD.equals(tenHDTim)) {
                result = true;
                check = true;
              }
              if (result == false) {
                tableModelHD.removeRow(i);
                i--;
              }
            }
            if (check == false) {
              loadTable();
              JOptionPane.showMessageDialog(null, "Không tìm thấy hoá đơn ngày " + tenHDTim);
            } else if (check == true) {
              JOptionPane.showMessageDialog(null, "Tìm thấy hoá đơn ngày " + tenHDTim);
            }
          }
        }
      }
    });
    pnlCenter.add(lbLTimNgayLapHD);
    pnlCenter.add(txtNgayLapHoaDon);

    txtTimKiemSDT = new PlaceholderTextField(Color.GRAY, false);
    txtTimKiemSDT.setPlaceholder("Nhập SDT/Mã hóa đơn");
    txtTimKiemSDT.setBounds(450, 10, 200, 30);
    txtTimKiemSDT.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 18));
    txtTimKiemSDT.setCursor(new Cursor(Cursor.TEXT_CURSOR));
    txtTimKiemSDT.setBorder(null);
    pnlCenter.add(txtTimKiemSDT);

    btnTimHD = new MyButton(15, Color.decode(Constants.BTN_FILTER_COLOR), Color.decode(Constants.BTN_FILTER_COLOR));
    btnTimHD.setText("Tìm kiếm");
    btnTimHD.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 18));
    btnTimHD.setBounds(700, 10, 150, 35);
    btnTimHD.setForeground(Color.WHITE);
    btnTimHD.setCursor(handCursor);
    btnTimHD.setBorderPainted(false);
    btnTimHD.setFocusPainted(false);
    btnTimHD.setIcon(FontIcon.of(FontAwesomeSolid.SEARCH, 20));
    pnlCenter.add(btnTimHD);

    btnRefreshDV = new MyButton(15, Color.decode(Constants.BTN_FILTER_COLOR), Color.decode(Constants.BTN_FILTER_COLOR));
    btnRefreshDV.setText("Làm mới");
    btnRefreshDV.setBounds(900, 10, 100, 35);
    btnRefreshDV.setForeground(Color.WHITE);
    btnRefreshDV.setBorder(null);
    btnRefreshDV.setCursor(handCursor);
    btnRefreshDV.setBorderPainted(false);
    btnRefreshDV.setFocusPainted(false);
    pnlCenter.add(btnRefreshDV);

    pnlMainUI.add(pnlCenter);
    btnTimHD.addActionListener(this);

    btnRefreshDV.addActionListener(this);
  }

  @Override
  public void actionPerformed(ActionEvent e) {
    String oldText = lblDanhSachCaLam.getText();
    String newText = oldText.substring(1) + oldText.substring(0, 1);
    lblDanhSachCaLam.setText(newText);
    try {
      if (e.getSource() == btnKhachHang) {
        new QuanLyKhachHang(tk, "").setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnPhong) {
        new QuanLyPhong(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnNhanVien) {
        new QLNhanVien(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnThongke) {
        new ThongKe(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnPhanCong) {
        new PhanCongCaLam(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnQuanLyDatPhong) {
        new QuanLyDatPhong(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnIconLogout) {
        int tb = JOptionPane.showConfirmDialog(this, "Bạn có chắc chắn muốn đăng xuất không", "Cảnh báo",
            JOptionPane.YES_NO_OPTION);
        if (tb == JOptionPane.YES_OPTION) {
          for (Frame frame : Frame.getFrames()) {
            frame.dispose();
          }
          new DangNhap().setVisible(true);
        }
      } else if (e.getSource() == btnDichVu) {
        new DichVuUI(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnIconUser) {
        new ThongTinNguoiDung(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnTroGiup) {
        Desktop.getDesktop().browse(new URL("https://ptud.netlify.app/").toURI());
      }
      // 0965799073

      if (e.getSource() == btnTimHD) {
        String txt = txtTimKiemSDT.getText();
        if (txt.length() == 10) {
          if (txt.matches("[0-9]+")) {
            List<HoaDon> list = hoaDonService.dsHoaDonTheoSDT(txt);
            tableModelHD.setRowCount(0);
            for (HoaDon hoaDon : list) {
              Object[] o = new Object[10];
              o[0] = hoaDon.getMaHD();
              o[1] = hoaDon.getNgayLapHD().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
              for (ChiTietHoaDon cthd : hoaDon.getCTHD()) {
                int thoigian = cthd.getThoiGianSuDung();
                int gio = thoigian / 60;
                int phut = thoigian % 60;
                o[2] = cthd.getPhong().getTenPhong();
                o[3] = String.valueOf(cthd.getPhong().getgiaPhong()).split("\\.")[0] + " VNĐ";
                o[4] = gio + " giờ " + phut + " phút";
              }
              for (ChiTietDichVu dv : hoaDon.getCTDV()) {
                o[5] = dv.getDichVu().getTenDichVu();
                o[6] = String.valueOf(dv.getDichVu().getGiaDichVu()).split("\\.")[0] + " VNĐ";
                o[7] = dv.getSoLuong();
                o[8] = hoaDon.getKhachHang().getTenKH();
                o[9] = hoaDon.getNhanVien().getTenNV();
                tableModelHD.addRow(o);
              }
            }
            for (int i = 0; i < tableModelHD.getRowCount(); i++) {
              String gio = tblHoaDon.getValueAt(i, 4).toString().split(" ")[0];
              String phut = tblHoaDon.getValueAt(i, 4).toString().split(" ")[2];
              if (gio.equals("0") && phut.equals("0")) {
                tableModelHD.removeRow(i);
                i--;
              }
            }
            txtTimKiemSDT.setText("");
          } else {
            JOptionPane.showMessageDialog(this, "Số điện thoại không hợp lệ", "Thông báo",
                JOptionPane.ERROR_MESSAGE);
          }
        } else if (txt.length() == 16) {
          List<HoaDon> list = hoaDonService.dsHoaDonTheoSDT(txt);
          tableModelHD.setRowCount(0);
          for (HoaDon hoaDon : list) {
            Object[] o = new Object[10];
            o[0] = hoaDon.getMaHD();
            o[1] = hoaDon.getNgayLapHD().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            for (ChiTietHoaDon cthd : hoaDon.getCTHD()) {
              int thoigian = cthd.getThoiGianSuDung();
              int gio = thoigian / 60;
              int phut = thoigian % 60;
              o[2] = cthd.getPhong().getTenPhong();
              o[3] = String.valueOf(cthd.getPhong().getgiaPhong()).split("\\.")[0] + " VNĐ";
              o[4] = gio + " giờ " + phut + " phút";
            }

            for (ChiTietDichVu dv : hoaDon.getCTDV()) {
              o[5] = dv.getDichVu().getTenDichVu();
              o[6] = String.valueOf(dv.getDichVu().getGiaDichVu()).split("\\.")[0] + " VNĐ";
              o[7] = dv.getSoLuong();
            }
            if (hoaDon.getKhachHang() == null) {
              o[8] = "Khách vãn lai";
            } else {
              o[8] = hoaDon.getKhachHang().getTenKH();
            }
            o[9] = hoaDon.getNhanVien().getTenNV();
            tableModelHD.addRow(o);
          }
          for (int i = 0; i < tableModelHD.getRowCount(); i++) {
            String gio = tblHoaDon.getValueAt(i, 4).toString().split(" ")[0];
            String phut = tblHoaDon.getValueAt(i, 4).toString().split(" ")[2];
            if (gio.equals("0") && phut.equals("0")) {
              tableModelHD.removeRow(i);
              i--;
            }
          }
          txtTimKiemSDT.setText("");
        }
      } else if (e.getSource() == btnRefreshDV) {
        loadTable();
        clearTextField();
        txtTimKiemSDT.setText("");
      }
    } catch (

    Exception e1) {
      e1.printStackTrace();
    }
  }

  private String layNgayhoadon(int ngaylaphoadon) {
    String ngay = String.valueOf(ngaylaphoadon);
    if (ngay.matches("[1-9]")) {
      ngay = "0" + ngay;
    }
    return ngay;
  }

  private String laythanghoadon(int thanghoadon) {
    String thang = String.valueOf(thanghoadon);
    if (thang.matches("[1-9]")) {
      thang = "0" + thang;
    }
    return thang;
  }

  private void clearTextField() {
  }

  private void loadTable() {

    tableModelHD.setRowCount(0);
    for (HoaDon hoaDon : hoaDonService.dsHoaDonChiTietVangLai()) {
      Object[] o = new Object[10];
      o[0] = hoaDon.getMaHD();
      o[1] = hoaDon.getNgayLapHD().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
      for (ChiTietHoaDon cthd : hoaDon.getCTHD()) {
        int thoigian = cthd.getThoiGianSuDung();
        int gio = thoigian / 60;
        int phut = thoigian % 60;
        o[2] = cthd.getPhong().getTenPhong();
        o[3] = String.valueOf(cthd.getPhong().getgiaPhong()).split("\\.")[0] + " VNĐ";
        o[4] = gio + " giờ " + phut + " phút";
      }

      for (ChiTietDichVu dv : hoaDon.getCTDV()) {
        o[5] = dv.getDichVu().getTenDichVu();
        o[6] = String.valueOf(dv.getDichVu().getGiaDichVu()).split("\\.")[0] + " VNĐ";
        o[7] = dv.getSoLuong();
      }
      if (hoaDon.getKhachHang() == null) {
        o[8] = "Khách vãn lai";
      }
      o[9] = hoaDon.getNhanVien().getTenNV();
      tableModelHD.addRow(o);
    }
    for (HoaDon hoaDon : hoaDonService.dsHoaDon()) {
      Object[] o = new Object[10];
      o[0] = hoaDon.getMaHD();
      o[1] = hoaDon.getNgayLapHD().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));

      for (ChiTietHoaDon cthd : hoaDon.getCTHD()) {
        int thoigian = cthd.getThoiGianSuDung();
        int gio = thoigian / 60;
        int phut = thoigian % 60;
        o[2] = cthd.getPhong().getTenPhong();
        o[3] = String.valueOf(cthd.getPhong().getgiaPhong()).split("\\.")[0] + " VNĐ";
        o[4] = gio + " giờ " + phut + " phút";
      }
      for (ChiTietDichVu dv : hoaDon.getCTDV()) {
        o[5] = dv.getDichVu().getTenDichVu();
        o[6] = String.valueOf(dv.getDichVu().getGiaDichVu()).split("\\.")[0] + " VNĐ";
        o[7] = dv.getSoLuong();
        o[8] = hoaDon.getKhachHang().getTenKH();
        o[9] = hoaDon.getNhanVien().getTenNV();
        tableModelHD.addRow(o);
      }
    }
    for (int i = 0; i < tableModelHD.getRowCount(); i++) {
      String gio = tblHoaDon.getValueAt(i, 4).toString().split(" ")[0];
      String phut = tblHoaDon.getValueAt(i, 4).toString().split(" ")[2];
      if (gio.equals("0") && phut.equals("0")) {
        tableModelHD.removeRow(i);
        i--;
      }
    }

  }

}