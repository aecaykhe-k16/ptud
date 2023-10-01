package ui;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Cursor;
import java.awt.Frame;
import java.awt.Desktop;
import java.awt.Font;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.SQLException;
import java.text.DecimalFormat;

import javax.imageio.ImageIO;
import javax.swing.AbstractAction;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JComponent;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JLayeredPane;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.KeyStroke;
import javax.swing.Timer;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;

import org.kordamp.ikonli.fontawesome5.FontAwesomeSolid;
import org.kordamp.ikonli.swing.FontIcon;

import bus.IDangNhapService;
import bus.IDichVuService;
import bus.IPhanCongCaLamService;
import bus.implement.DangNhapImp;
import bus.implement.DichVuImp;
import bus.implement.PhanCongCaLamImp;
import entities.DichVu;
import entities.TaiKhoan;
import util.ConnectDB;
import util.Constants;
import util.Generator;
import util.MyButton;
import util.PlaceholderTextField;
import util.RoundedBorderWithColor;
import util.SpecialButton;

public class DichVuUI extends JFrame implements ActionListener {
  private JPanel pnlMainUI, pnlCenter, pnlMenu, pnlTop, pnInfo;
  private JTable tblDichVu;
  private DefaultTableModel tableModelDV;
  private JLabel lblIconLogo, lblTitle, lblDanhSachCaLam;
  private JButton btnIconLogout, btnIconUser, btnChonAnh;
  private JButton btnThemDV, btnSuaDV, btnXoaDV, btnTimDV, btnLocDV, btnRefreshDV;
  private JComboBox<String> cmbGiaTu, cmbGiaDen;
  private JLabel lblTenBang, lblTenDichVu, lblGia, lblSoLuong, lblHinhAnh;
  private JTextField txtTenDichVu, txtGia, txtSoLuong;
  private PlaceholderTextField txtTimDV;
  private Cursor handCursor = new Cursor(Cursor.HAND_CURSOR);
  Generator gen = new Generator();

  private IDichVuService dichVuService = new DichVuImp();
  private IDangNhapService dangNhap = new DangNhapImp();
  private TaiKhoan tk;
  private JLabel lblNhanVien, lblPhong, lblKhachHang, lblHoaDon, lblThongke, lblPhanCong,
      lblQuanLyDatPhong, lblDichVu;

  // slidebar
  private JButton btnNhanVien, btnPhong, btnKhachHang, btnThongke, btnPhanCong, btnTroGiup,
      btnQuanLyDatPhong, btnDichVu, btnHoaDon;

  private JLayeredPane layeredPane;
  private IPhanCongCaLamService caLamService = new PhanCongCaLamImp();
  URL url = new URL(Constants.LOGO);
  Image imageIcon = new ImageIcon(url).getImage().getScaledInstance(100, 75, Image.SCALE_SMOOTH);
  private JButton picHinhAnh;
  private String pathImg = "";

  public DichVuUI(TaiKhoan taiKhoan) throws MalformedURLException {
    try {
      ConnectDB.getInstance().connect();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    tk = taiKhoan;
    setTitle(Constants.APP_NAME);
    setSize(1300, 700);
    setDefaultCloseOperation(EXIT_ON_CLOSE);
    setLocationRelativeTo(null);
    this.setBackground(Color.WHITE);
    this.setIconImage(imageIcon);
    setResizable(false);
    setLayout(null);
    layeredPane = new JLayeredPane();
    layeredPane.setBounds(0, 0, 1300, 1500);
    add(layeredPane);
    MainUI();
  }

  private void MainUI() {
    pnlMainUI = new JPanel();
    pnlMainUI.setLayout(null);
    pnlMainUI.setBounds(0, 0, 1300, 1400);
    PnlTop();
    PnlMenu();
    PnlCenter();
    PnlTable();
    layeredPane.add(pnlMainUI, Integer.valueOf(1));

    btnThemDV.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F1, 0),
        "btnThemDV");
    btnThemDV.getActionMap().put("btnThemDV", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnThemDV.doClick();
      }
    });
    btnSuaDV.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F2, 0),
        "btnSuaDV");
    btnSuaDV.getActionMap().put("btnSuaDV", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnSuaDV.doClick();
      }
    });
    btnXoaDV.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F3, 0),
        "btnXoaDV");
    btnXoaDV.getActionMap().put("btnXoaDV", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnXoaDV.doClick();
      }
    });
    btnLocDV.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F4, 0),
        "btnLocDV");
    btnLocDV.getActionMap().put("btnLocDV", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnLocDV.doClick();
      }
    });
    btnRefreshDV.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F5, 0),
        "btnRefreshDV");
    btnRefreshDV.getActionMap().put("btnRefreshDV", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnRefreshDV.doClick();
      }
    });
    btnTimDV.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_ENTER, 0),
        "btnTimDV");
    btnTimDV.getActionMap().put("btnTimDV", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnTimDV.doClick();
      }
    });

    tblDichVu.addMouseListener(new MouseListener() {

      @Override
      public void mouseClicked(MouseEvent e) {
        int row = tblDichVu.getSelectedRow();
        String tenDV = (String) tblDichVu.getValueAt(row, 1);
        String gia = (String) tblDichVu.getValueAt(row, 2);
        int soLuong = (int) tblDichVu.getValueAt(row, 3);
        String hinhanh = (String) tblDichVu.getValueAt(row, 4);
        String soluongDV = String.valueOf(soLuong);

        txtTenDichVu.setText(tenDV);
        txtGia.setText(gen.convertGia(gia));
        txtSoLuong.setText(soluongDV);
        picHinhAnh.setIcon(new ImageIcon(hinhanh));
      }

      @Override
      public void mousePressed(MouseEvent e) {
      }

      @Override
      public void mouseReleased(MouseEvent e) {
      }

      @Override
      public void mouseEntered(MouseEvent e) {
      }

      @Override
      public void mouseExited(MouseEvent e) {
      }
    });
  }

  void PnlTable() {
    JPanel pnBang = new JPanel();
    pnBang.setLayout(new BorderLayout());

    String[] header = { "Mã dịch vụ", "Tên dịch vụ", "Giá", "Số lượng", "Hình ảnh" };
    tableModelDV = new DefaultTableModel(header, 0);
    tblDichVu = new JTable(tableModelDV);
    JScrollPane scrollPane = new JScrollPane(tblDichVu);
    tblDichVu.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 15));
    tblDichVu.setRowHeight(20);
    tblDichVu.getTableHeader().setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 15));
    tblDichVu.getColumnModel().getColumn(4).setMinWidth(0);
    tblDichVu.getColumnModel().getColumn(4).setMaxWidth(0);
    tblDichVu.getColumnModel().getColumn(4).setWidth(0);
    pnBang.add(scrollPane);
    pnBang.setBounds(15, 210, 600, 440);
    tblDichVu.setDefaultEditor(Object.class, null);
    DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
    centerRenderer.setHorizontalAlignment(JLabel.CENTER);
    for (int x = 0; x < 4; x++) {
      tblDichVu.getColumnModel().getColumn(x).setCellRenderer(centerRenderer);
    }
    loadTable();

    pnlMainUI.add(pnBang);
  }

  void PnlCenter() {
    lblTenBang = new JLabel("Danh sách dịch vụ:");
    lblTenBang.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    lblTenBang.setBounds(40, 175, 200, 30);
    lblTenBang.setForeground(Color.decode(Constants.MENU_TITLE_COLOR));
    pnlMainUI.add(lblTenBang);
    btnRefreshDV = new JButton("");
    btnRefreshDV.setBounds(550, 180, 30, 30);
    btnRefreshDV.setBackground(Color.decode(Constants.THIRD_COLOR));
    btnRefreshDV.setBorder(null);
    btnRefreshDV.setIcon(FontIcon.of(FontAwesomeSolid.REDO, 20));
    btnRefreshDV.setToolTipText("Refresh");
    btnRefreshDV.setCursor(handCursor);
    btnRefreshDV.setBorderPainted(false);
    btnRefreshDV.setFocusPainted(false);
    pnlMainUI.add(btnRefreshDV);

    pnlCenter = new JPanel();
    pnlCenter.setBounds(620, 210, 800, 600);
    pnlCenter.setLayout(null);

    lblTenDichVu = new JLabel("Tên dịch vụ:");
    lblTenDichVu.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    lblTenDichVu.setBounds(20, 0, 200, 30);
    pnlCenter.add(lblTenDichVu);
    txtTenDichVu = new JTextField();
    txtTenDichVu.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    txtTenDichVu.setBounds(130, 0, 500, 30);
    txtTenDichVu.setBorder(new RoundedBorderWithColor(Color.decode(Constants.THIRD_COLOR), 1, 15));
    txtTenDichVu.setBackground(Color.WHITE);
    pnlCenter.add(txtTenDichVu);

    lblGia = new JLabel("Giá:");
    lblGia.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    lblGia.setBounds(20, 40, 200, 30);
    pnlCenter.add(lblGia);
    txtGia = new JTextField();
    txtGia.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    txtGia.setBounds(130, 40, 500, 30);
    txtGia.setBorder(new RoundedBorderWithColor(Color.decode(Constants.THIRD_COLOR), 1, 15));
    txtGia.setBackground(Color.WHITE);
    pnlCenter.add(txtGia);

    lblSoLuong = new JLabel("Số lượng:");
    lblSoLuong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    lblSoLuong.setBounds(20, 80, 200, 30);
    pnlCenter.add(lblSoLuong);
    txtSoLuong = new JTextField();
    txtSoLuong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    txtSoLuong.setBounds(130, 80, 500, 30);
    txtSoLuong.setBorder(new RoundedBorderWithColor(Color.decode(Constants.THIRD_COLOR), 1, 15));
    txtSoLuong.setBackground(Color.WHITE);
    pnlCenter.add(txtSoLuong);

    lblHinhAnh = new JLabel("Hình ảnh:");
    lblHinhAnh.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    lblHinhAnh.setBounds(20, 120, 200, 30);
    pnlCenter.add(lblHinhAnh);

    btnChonAnh = new MyButton(0, Color.decode("#eeeeee"), Color.decode("#eeeeee"));
    btnChonAnh.setBounds(130, 120, 30, 30);
    FontIcon iconFolder = FontIcon.of(FontAwesomeSolid.FOLDER_OPEN, 25, Color.BLACK);
    btnChonAnh.setIcon(iconFolder);
    btnChonAnh.setBorderPainted(false);
    btnChonAnh.setContentAreaFilled(false);
    btnChonAnh.setFocusPainted(false);
    btnChonAnh.setOpaque(false);
    btnChonAnh.setEnabled(false);
    btnChonAnh.setCursor(handCursor);
    pnlCenter.add(btnChonAnh);
    btnChonAnh.addActionListener(this);

    picHinhAnh = new JButton();
    picHinhAnh.setBounds(170, 120, 70, 70);
    picHinhAnh.setBackground(Color.decode(Constants.THIRD_COLOR));
    picHinhAnh.setBorderPainted(false);
    picHinhAnh.setFocusPainted(false);
    picHinhAnh.setContentAreaFilled(false);
    picHinhAnh.setOpaque(false);
    pnlCenter.add(picHinhAnh);

    btnThemDV = new MyButton(15, Color.decode(Constants.BTN_CONFIRM_COLOR),
        Color.decode(Constants.THIRD_COLOR));
    btnThemDV.setText("Thêm(F1)");
    btnThemDV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    btnThemDV.setBounds(70, 200, 140, 40);
    btnThemDV.setForeground(Color.WHITE);
    btnThemDV.setCursor(handCursor);
    btnThemDV.setBorderPainted(false);
    btnThemDV.setFocusPainted(false);
    btnThemDV.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
    pnlCenter.add(btnThemDV);

    btnSuaDV = new MyButton(15, Color.decode(Constants.BTN_EDIT_COLOR), Color.decode(Constants.THIRD_COLOR));
    btnSuaDV.setText("Sửa(F2)");
    btnSuaDV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    btnSuaDV.setBounds(260, 200, 140, 40);
    btnSuaDV.setForeground(Color.WHITE);
    btnSuaDV.setCursor(handCursor);
    btnSuaDV.setBorderPainted(false);
    btnSuaDV.setFocusPainted(false);
    btnSuaDV.setIcon(FontIcon.of(FontAwesomeSolid.EDIT, 20));
    pnlCenter.add(btnSuaDV);

    btnXoaDV = new MyButton(15, Color.WHITE, Color.WHITE);
    btnXoaDV.setText("Xóa(F3)");
    btnXoaDV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    btnXoaDV.setBounds(460, 200, 170, 40);
    btnXoaDV.setForeground(Color.BLACK);
    btnXoaDV.setCursor(handCursor);
    btnXoaDV.setBorderPainted(false);
    btnXoaDV.setFocusPainted(false);
    btnXoaDV.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
    pnlCenter.add(btnXoaDV);

    // tạo mảng giá tiền của dịch vụ
    Double gia[] = { 0.0, 10000.0, 20000.0, 30000.0, 40000.0, 50000.0, 60000.0, 70000.0,
        80000.0, 90000.0, 100000.0, 110000.0, 120000.0, 130000.0, 140000.0,
        150000.0, 160000.0, 170000.0, 180000.0, 190000.0, 200000.0, 500000.0, 1000000.0 };

    cmbGiaTu = new JComboBox<String>();
    cmbGiaTu.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    cmbGiaTu.setBounds(50, 280, 350, 30);
    pnlCenter.add(cmbGiaTu);

    cmbGiaDen = new JComboBox<String>();
    cmbGiaDen.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    cmbGiaDen.setBounds(50, 340, 350, 30);
    pnlCenter.add(cmbGiaDen);

    String pattern = "###,###.##VND";
    DecimalFormat dcfVND = new DecimalFormat(pattern);
    for (Double string : gia) {
      String format = dcfVND.format(string);
      cmbGiaTu.addItem(format);
      cmbGiaDen.addItem(format);
    }

    btnLocDV = new MyButton(15, Color.decode(Constants.BTN_FILTER_COLOR), Color.decode(Constants.BTN_FILTER_COLOR));
    btnLocDV.setText("Lọc theo giá(F4)");
    btnLocDV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 18));
    btnLocDV.setBounds(430, 305, 200, 40);
    btnLocDV.setForeground(Color.WHITE);
    btnLocDV.setCursor(handCursor);
    btnLocDV.setBorderPainted(false);
    btnLocDV.setFocusPainted(false);
    btnLocDV.setIcon(FontIcon.of(FontAwesomeSolid.FILTER, 20));
    pnlCenter.add(btnLocDV);

    txtTimDV = new PlaceholderTextField(Color.GRAY, false);
    txtTimDV.setPlaceholder("Nhập tên dịch vụ");
    txtTimDV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    txtTimDV.setBounds(20, 400, 440, 35);
    txtTimDV.setBorder(new RoundedBorderWithColor(Color.decode(Constants.THIRD_COLOR), 1, 15));
    pnlCenter.add(txtTimDV);
    btnTimDV = new MyButton(15, Color.decode(Constants.BTN_FILTER_COLOR), Color.decode(Constants.BTN_FILTER_COLOR));
    btnTimDV.setText("Tìm kiếm");
    btnTimDV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 18));
    btnTimDV.setBounds(470, 400, 160, 35);
    btnTimDV.setForeground(Color.WHITE);
    btnTimDV.setCursor(handCursor);
    btnTimDV.setBorderPainted(false);
    btnTimDV.setFocusPainted(false);
    btnTimDV.setIcon(FontIcon.of(FontAwesomeSolid.SEARCH, 20));
    pnlCenter.add(btnTimDV);

    unlockTextField(false);

    pnlMainUI.add(pnlCenter);
    btnTimDV.addActionListener(this);
    btnLocDV.addActionListener(this);
    btnThemDV.addActionListener(this);
    btnSuaDV.addActionListener(this);
    btnXoaDV.addActionListener(this);
    btnRefreshDV.addActionListener(this);
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
      lblNhanVien.setBounds(140, 0, 10, 50);
      btnNhanVien = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnNhanVien.setText("Nhân viên");
      btnNhanVien.setFont(f2);
      btnNhanVien.setBounds(0, 0, 140, 50);
      btnNhanVien.setBorder(null);
      btnNhanVien.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnNhanVien.setCursor(handCursor);
      btnNhanVien.setIcon(FontIcon.of(FontAwesomeSolid.USERS, 30));
      btnNhanVien.setFocusPainted(false);

      lblPhong = new JLabel(new ImageIcon(line));
      lblPhong.setBounds(280, 0, 10, 50);
      btnPhong = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnPhong.setText("Phòng");
      btnPhong.setFont(f2);
      btnPhong.setBounds(140, 0, 140, 50);
      btnPhong.setBorder(null);
      btnPhong.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnPhong.setCursor(handCursor);
      btnPhong.setIcon(FontIcon.of(FontAwesomeSolid.DOOR_CLOSED, 30));
      btnPhong.setFocusPainted(false);

      lblKhachHang = new JLabel(new ImageIcon(line));
      lblKhachHang.setBounds(420, 0, 10, 50);
      btnKhachHang = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnKhachHang.setText("Khách hàng");
      btnKhachHang.setFont(f2);
      btnKhachHang.setBounds(280, 0, 140, 50);
      btnKhachHang.setBorder(null);
      btnKhachHang.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnKhachHang.setCursor(handCursor);
      btnKhachHang.setIcon(FontIcon.of(FontAwesomeSolid.USER_TIE, 30));
      btnKhachHang.setFocusPainted(false);

      lblHoaDon = new JLabel(new ImageIcon(line));
      lblHoaDon.setBounds(560, 0, 10, 50);
      btnHoaDon = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnHoaDon.setText("Hóa đơn");
      btnHoaDon.setFont(f2);
      btnHoaDon.setBounds(420, 0, 140, 50);
      btnHoaDon.setBorder(null);
      btnHoaDon.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnHoaDon.setCursor(handCursor);
      btnHoaDon.setIcon(FontIcon.of(FontAwesomeSolid.RECEIPT, 30));
      btnHoaDon.setFocusPainted(false);

      lblThongke = new JLabel(new ImageIcon(line));
      btnThongke = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      ;
      lblThongke.setBounds(700, 0, 10, 50);
      btnThongke.setText("Thống kê");
      btnThongke.setFont(f2);
      btnThongke.setBounds(560, 0, 140, 50);
      btnThongke.setBorder(null);
      btnThongke.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnThongke.setCursor(handCursor);
      btnThongke.setIcon(FontIcon.of(FontAwesomeSolid.CHART_BAR, 30));
      btnThongke.setFocusPainted(false);

      lblPhanCong = new JLabel(new ImageIcon(line));
      lblPhanCong.setBounds(840, 0, 10, 50);
      btnPhanCong = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));

      btnPhanCong.setText("Phân công");
      btnPhanCong.setFont(f2);
      btnPhanCong.setBounds(700, 0, 140, 50);
      btnPhanCong.setBorder(null);
      btnPhanCong.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnPhanCong.setCursor(handCursor);
      btnPhanCong.setIcon(FontIcon.of(FontAwesomeSolid.TASKS, 30));
      btnPhanCong.setFocusPainted(false);

      lblQuanLyDatPhong = new JLabel(new ImageIcon(line));
      lblQuanLyDatPhong.setBounds(980, 0, 10, 50);
      btnQuanLyDatPhong = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));

      btnQuanLyDatPhong.setText("Đặt phòng");
      btnQuanLyDatPhong.setFont(f2);
      btnQuanLyDatPhong.setBounds(840, 0, 140, 50);
      btnQuanLyDatPhong.setBorder(null);
      btnQuanLyDatPhong.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnQuanLyDatPhong.setCursor(handCursor);
      btnQuanLyDatPhong.setIcon(FontIcon.of(FontAwesomeSolid.TH, 30));
      btnQuanLyDatPhong.setFocusPainted(false);

      lblDichVu = new JLabel(new ImageIcon(line));
      lblDichVu.setBounds(1120, 0, 10, 50);
      btnDichVu = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));

      btnDichVu.setText("Dịch vụ");
      btnDichVu.setFont(f2);
      btnDichVu.setBounds(980, 0, 140, 50);
      btnDichVu.setBorder(null);
      btnDichVu.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnDichVu.setCursor(handCursor);

      btnDichVu.setIcon(FontIcon.of(FontAwesomeSolid.CONCIERGE_BELL, 30, Color.decode("#7743DB")));
      btnDichVu.setFocusPainted(false);

      btnTroGiup = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnTroGiup.setText("Trợ giúp");
      btnTroGiup.setFont(f2);
      btnTroGiup.setBounds(1120, 0, 170, 50);
      btnTroGiup.setBorder(null);
      btnTroGiup.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnTroGiup.setCursor(handCursor);
      btnTroGiup.setIcon(FontIcon.of(FontAwesomeSolid.QUESTION_CIRCLE, 30));
    } catch (Exception e) {
      e.printStackTrace();
    }

    if (dangNhap.getNV(tk.getEmail()).getQuanLy() == null) {
      lblKhachHang.setBounds(140, 0, 10, 50);
      btnKhachHang.setBounds(0, 0, 140, 50);
      lblHoaDon.setBounds(280, 0, 10, 50);
      btnHoaDon.setBounds(140, 0, 140, 50);
      lblThongke.setBounds(420, 0, 10, 50);
      btnThongke.setBounds(280, 0, 140, 50);
      lblQuanLyDatPhong.setBounds(560, 0, 10, 50);
      btnQuanLyDatPhong.setBounds(420, 0, 140, 50);
      lblDichVu.setBounds(700, 0, 10, 50);
      btnDichVu.setBounds(560, 0, 140, 50);
      btnTroGiup.setBounds(700, 0, 170, 50);
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
    pnlTop.setBounds(0, 0, 1400, 100);

    pnlTop.setBackground(Color.decode(Constants.TITLE_COLOR));

    pnlTop.setLayout(null);

    lblIconLogo = new JLabel();
    lblIconLogo.setBounds(50, 0, 200, 100);
    lblIconLogo.setIcon(new ImageIcon(imageIcon));

    lblTitle = new JLabel(Constants.TITLE);
    lblTitle.setBounds(400, 0, 750, 100);
    lblTitle.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 60));
    lblTitle.setForeground(Color.decode("#FFFFFFF"));

    pnInfo = new JPanel();
    pnInfo.setBounds(1050, 0, 250, 100);
    pnInfo.setBackground(Color.decode(Constants.TITLE_COLOR));
    pnInfo.setLayout(null);

    btnIconUser = new SpecialButton(0, Color.decode(Constants.TITLE_COLOR), Color.decode(Constants.TITLE_COLOR));
    btnIconUser.setText(dangNhap.getNV(tk.getEmail()).getTenNV());
    btnIconUser.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 16));
    btnIconUser.setBounds(0, 0, 250, 50);
    btnIconUser.setBorder(null);
    btnIconUser.setBackground(Color.decode(Constants.TITLE_COLOR));

    btnIconUser.setForeground(Color.WHITE);
    btnIconUser.setIcon(FontIcon.of(FontAwesomeSolid.USER, 30, Color.WHITE));
    btnIconUser.setBorderPainted(false);
    btnIconUser.setFocusPainted(false);

    btnIconLogout = new SpecialButton(0, Color.decode(Constants.TITLE_COLOR), Color.decode(Constants.TITLE_COLOR));
    btnIconLogout.setText(Constants.DANG_XUAT);
    btnIconLogout.setBounds(30, 50, 200, 50);
    btnIconLogout.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 16));
    btnIconLogout.setBorder(null);
    btnIconLogout.setBackground(Color.decode(Constants.TITLE_COLOR));
    btnIconLogout.setForeground(Color.WHITE);
    btnIconLogout.setIcon(FontIcon.of(FontAwesomeSolid.SIGN_OUT_ALT, 30, Color.RED));
    btnIconLogout.setBorderPainted(false);
    btnIconLogout.setFocusPainted(false);
    btnIconUser.setCursor(handCursor);
    btnIconLogout.setCursor(handCursor);
    lblDanhSachCaLam = new JLabel(caLamService.getCaTucTheoNV(tk.getEmail()));
    lblDanhSachCaLam.setBounds(900, 70, 200, 20);
    lblDanhSachCaLam.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    lblDanhSachCaLam.setForeground(Color.decode("#FFFFFFF"));
    Timer t = new Timer(500, this); // set a timer
    // set animation for timer
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
      } else if (e.getSource() == btnHoaDon) {
        new HoaDonUi(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnIconUser) {
        new ThongTinNguoiDung(tk).setVisible(true);
      } else if (e.getSource() == btnTroGiup) {
        Desktop.getDesktop().browse(new URL("https://ptud.netlify.app/").toURI());
      }
    } catch (Exception e1) {
      e1.printStackTrace();
    }

    if (e.getSource() == btnChonAnh) {
      JFileChooser fileChooser = new JFileChooser("G:/ptud/ptud/assets/images");
      fileChooser.setDialogTitle("Chọn ảnh");
      // set icon cho file chooser

      fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
      fileChooser.setAcceptAllFileFilterUsed(false);
      FileNameExtensionFilter filter = new FileNameExtensionFilter("PNG, JPG, JPEG", "png", "jpg", "jpeg");
      fileChooser.addChoosableFileFilter(filter);
      int result = fileChooser.showOpenDialog(null);
      if (result == JFileChooser.APPROVE_OPTION) {
        File selectedFile = fileChooser.getSelectedFile();
        String path = selectedFile.getAbsolutePath();
        for (int index = 0; index < path.length(); index++) {
          if (path.charAt(index) == 'a' && path.charAt(index + 1) == 's' && path.charAt(index + 2) == 's'
              && path.charAt(index + 3) == 'e' && path.charAt(index + 4) == 't' && path.charAt(index + 5) == 's'
              && path.charAt(index + 6) == '\\') {
            pathImg = path.substring(index);
          }
        }

        try {
          picHinhAnh
              .setIcon(new ImageIcon(ImageIO.read(new File(pathImg)).getScaledInstance(70, 70, Image.SCALE_SMOOTH)));
        } catch (IOException e1) {
          e1.printStackTrace();
        }
      }
    } else if (e.getSource() == btnThemDV) {
      if (btnThemDV.getText().equals("Thêm(F1)")) {
        btnSuaDV.setText("Hủy(F2)");
        btnThemDV.setText("Lưu(F1)");
        btnXoaDV.setText("Xóa trắng(F3)");
        txtTenDichVu.requestFocus();
        btnThemDV.setIcon(FontIcon.of(FontAwesomeSolid.SAVE, 20));
        btnSuaDV.setIcon(FontIcon.of(FontAwesomeSolid.TIMES, 20));
        btnXoaDV.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
        clearTextField();
        unlockTextField(true);
      } else if (btnThemDV.getText().equals("Lưu(F1)")) {
        themDichVu();
      } else if (btnThemDV.getText().equals("Hủy(F1)")) {
        clearTextField();
        btnThemDV.setText("Thêm(F1)");
        btnSuaDV.setText("Sửa(F2)");
        btnXoaDV.setText("Xóa(F3)");
        btnThemDV.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
        btnSuaDV.setIcon(FontIcon.of(FontAwesomeSolid.SAVE, 20));
        btnXoaDV.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
        unlockTextField(false);
        btnThemDV.setBackground(Color.decode(Constants.BTN_CONFIRM_COLOR));
        btnSuaDV.setBackground(Color.decode(Constants.BTN_EDIT_COLOR));
      }
    } else if (e.getSource() == btnSuaDV) {
      if (btnSuaDV.getText().equals("Sửa(F2)")) {
        int row = tblDichVu.getSelectedRow();
        if (row == -1) {
          JOptionPane.showMessageDialog(null, "Hãy chọn dịch vụ cần sửa");
        } else {
          txtTenDichVu.requestFocus();
          btnSuaDV.setText("Lưu(F2)");
          btnThemDV.setText("Hủy(F1)");
          btnXoaDV.setText("Xóa trắng(F3)");
          btnThemDV.setIcon(FontIcon.of(FontAwesomeSolid.TIMES, 20));
          btnSuaDV.setIcon(FontIcon.of(FontAwesomeSolid.SAVE, 20));
          btnXoaDV.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
          unlockTextField(true);
          btnThemDV.setBackground(Color.decode(Constants.BTN_CONFIRM_COLOR));
          btnSuaDV.setBackground(Color.decode(Constants.BTN_EDIT_COLOR));
        }
      } else if (btnSuaDV.getText().equals("Hủy(F2)")) {
        clearTextField();
        btnThemDV.setText("Thêm(F1)");
        btnSuaDV.setText("Sửa(F2)");
        btnXoaDV.setText("Xóa(F3)");
        btnThemDV.setBackground(Color.decode(Constants.BTN_CONFIRM_COLOR));
        btnSuaDV.setBackground(Color.decode(Constants.BTN_EDIT_COLOR));
        btnThemDV.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
        btnSuaDV.setIcon(FontIcon.of(FontAwesomeSolid.EDIT, 20));
        btnXoaDV.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
        unlockTextField(false);
      } else if (btnSuaDV.getText().equals("Lưu(F2)")) {
        if (checkTextField()) {
          suaDichVu();
        } else {
          JOptionPane.showMessageDialog(null, "Vui lòng nhập đầy đủ thông tin");
        }
      }
    } else if (e.getSource() == btnXoaDV) {
      if (btnXoaDV.getText().equals("Xóa(F3)")) {
        int row = tblDichVu.getSelectedRow();
        if (row == -1) {
          JOptionPane.showMessageDialog(null, "Bạn chưa chọn dịch vụ cần xóa");
        } else {
          int dialogButton = JOptionPane.showConfirmDialog(null,
              "Bạn có chắc chắn muốn xóa dịch vụ này không?",
              "Xác nhận",
              JOptionPane.YES_NO_OPTION);
          if (dialogButton == JOptionPane.YES_OPTION) {
            String maDV = tblDichVu.getValueAt(row, 0).toString();
            if (dichVuService.xoaDichVu(maDV) == true) {
              tableModelDV.removeRow(row);
              JOptionPane.showMessageDialog(null, "Xóa dịch vụ thành công");
            } else {
              JOptionPane.showMessageDialog(null, "Xóa dịch vụ thất bại");
            }
          }
        }

        clearTextField();
      }
      if (btnXoaDV.getText().equals("Xóa trắng(F3)")) {
        clearTextField();
      }

    } else if (e.getSource() == btnLocDV) {

      String tu = cmbGiaTu.getSelectedItem().toString();
      Double giaTu = Double.parseDouble(gen.convertGia(tu));
      String den = cmbGiaDen.getSelectedItem().toString();
      Double giaDen = Double.parseDouble(gen.convertGia(den));
      for (int i = 0; i < tableModelDV.getRowCount(); i++) {
        String gia = tableModelDV.getValueAt(i, 2).toString();
        Double giaDV = Double.parseDouble(gen.convertGia(gia));
        if (!(giaDV >= giaTu && giaDV <= giaDen)) {
          tableModelDV.removeRow(i);
          i--;
        }
      }
    } else if (e.getSource() == btnTimDV) {
      // tìm dịch vụ
      loadTable();
      String dvCanTim = txtTimDV.getText();
      Boolean kq = false;
      String ten = "";
      // search tên nhân viên
      for (int i = 0; i < tblDichVu.getRowCount(); i++) {
        Boolean result = false;
        String tenDV = tableModelDV.getValueAt(i, 1).toString();
        String[] arrName = tenDV.split(" ");
        for (int a = 0; a < arrName.length; a++) {
          if (a < arrName.length - 1) {
            ten = arrName[a] + " " + arrName[a + 1];
            if (ten.equals(dvCanTim)) {
              result = true;
              kq = true;
            } else if (ten.toLowerCase().equals(dvCanTim)) {
              result = true;
              kq = true;
            } else if (gen.boDauTrongTu(ten).equals(dvCanTim)) {
              result = true;
              kq = true;
            } else if (gen.boDauTrongTu(ten).toLowerCase().equals(dvCanTim)) {
              result = true;
              kq = true;
            }
          }

          if (arrName[a].equals(dvCanTim)) {
            result = true;
            kq = true;
          } else if (arrName[a].toLowerCase().equals(dvCanTim)) {
            result = true;
            kq = true;
          } else if (gen.boDauTrongTu(arrName[a]).equals(dvCanTim)) {
            result = true;
            kq = true;
          } else if (gen.boDauTrongTu(arrName[a]).toLowerCase().equals(dvCanTim)) {
            result = true;
            kq = true;
          }
        }
        if (tenDV.equals(dvCanTim)) {
          result = true;
          kq = true;
        }
        if (result == false) {
          tableModelDV.removeRow(i);
          i--;
        }

      }
      if (kq == true) {
        JOptionPane.showMessageDialog(null, "Tìm thấy dịch vụ");
        txtTimDV.setText("");
      } else {
        JOptionPane.showMessageDialog(null, "Không tìm thấy dịch vụ");
      }
    } else if (e.getSource() == btnRefreshDV) {
      loadTable();
      clearTextField();
    }
  }

  private void loadTable() {
    tableModelDV.setRowCount(0);

    dichVuService.dsDichVu().forEach(dv -> {
      String pattern = "###,###.##VND";
      DecimalFormat dcfVND = new DecimalFormat(pattern);
      String gia = dcfVND.format(dv.getGiaDichVu());
      tableModelDV.addRow(new Object[] {
          dv.getMaDichVu(),
          dv.getTenDichVu().trim(),
          gia,
          dv.getSlTon(),
          dv.getHinhAnh()
      });
    });
  }

  private boolean checkTextField() {
    if (txtTenDichVu.getText().equals("")) {
      JOptionPane.showMessageDialog(null, "Tên dịch vụ không được để trống");
      return false;
    } else if (txtGia.getText().equals("")) {
      JOptionPane.showMessageDialog(null, "Giá dịch vụ không được để trống");
      return false;
    } else if (txtSoLuong.getText().equals("")) {
      JOptionPane.showMessageDialog(null, "Số lượng không được để trống");
      return false;
    }
    return true;
  }

  private void clearTextField() {
    txtTenDichVu.setText("");
    txtGia.setText("");
    txtSoLuong.setText("");
    picHinhAnh.setIcon(null);
  }

  private void unlockTextField(Boolean lock) {
    txtTenDichVu.setEditable(lock);
    txtGia.setEditable(lock);
    txtSoLuong.setEditable(lock);
    btnChonAnh.setEnabled(lock);
  }

  private void themDichVu() {
    if (checkTextField()) {
      String tenDV = txtTenDichVu.getText();
      String giaDV = txtGia.getText();
      String soLuong = txtSoLuong.getText();
      String maDV = gen.taoMaDichVu();
      // kiểm tra trùng mã
      for (int i = 0; i < tableModelDV.getRowCount(); i++) {
        while (maDV.equals(tableModelDV.getValueAt(i, 0).toString())) {
          maDV = gen.taoMaDichVu();
        }
      }
      if (dichVuService.kiemTraDuLieu(giaDV, soLuong) == 1) {
        JOptionPane.showMessageDialog(null, "Giá dịch vụ phải là số");
      } else if (dichVuService.kiemTraDuLieu(giaDV, soLuong) == 2) {
        JOptionPane.showMessageDialog(null, "Số lượng phải là một con số");
      } else {
        Double gia = Double.parseDouble(giaDV);
        int soLuongDV = Integer.parseInt(soLuong);
        DichVu dv = new DichVu(maDV, tenDV, gia, soLuongDV, pathImg);
        if (dichVuService.themDichVu(dv) == true) {
          JOptionPane.showMessageDialog(null, "Thêm dịch vụ thành công");
          btnThemDV.setText("Thêm(F1)");
          btnSuaDV.setText("Sửa(F2)");
          btnXoaDV.setText("Xóa(F3)");
          btnThemDV.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
          btnSuaDV.setIcon(FontIcon.of(FontAwesomeSolid.EDIT, 20));
          btnXoaDV.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
          btnThemDV.setBackground(Color.decode(Constants.BTN_CONFIRM_COLOR));
          btnSuaDV.setBackground(Color.decode(Constants.BTN_EDIT_COLOR));
          clearTextField();
          loadTable();
          unlockTextField(false);
        } else {
          JOptionPane.showMessageDialog(null, "Thêm dịch vụ thất bại");
        }
      }
    }
  }

  private void suaDichVu() {
    int row = tblDichVu.getSelectedRow();
    String maDV = tblDichVu.getValueAt(row, 0).toString();
    String tenDV = txtTenDichVu.getText();
    String giaDV = txtGia.getText();
    String soLuong = txtSoLuong.getText();
    if (dichVuService.kiemTraDuLieu(giaDV, soLuong) == 1) {
      JOptionPane.showMessageDialog(null, "Giá dịch vụ phải là số");
    } else if (dichVuService.kiemTraDuLieu(giaDV, soLuong) == 2) {
      JOptionPane.showMessageDialog(null, "Số lượng phải là một con số");
    } else if (dichVuService.kiemTraDuLieu(giaDV, soLuong) == 0) {
      Double gia = Double.parseDouble(giaDV);
      int soLuongDV = Integer.parseInt(soLuong);
      DichVu dv = new DichVu(maDV, tenDV, gia, soLuongDV, pathImg);
      if (dichVuService.suaDichVu(dv) == true) {
        JOptionPane.showMessageDialog(null, "Sửa thành công");
        btnThemDV.setText("Thêm(F1)");
        btnSuaDV.setText("Sửa(F2)");
        btnXoaDV.setText("Xóa(F3)");
        btnThemDV.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
        btnSuaDV.setIcon(FontIcon.of(FontAwesomeSolid.EDIT, 20));
        btnXoaDV.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
        btnThemDV.setBackground(Color.decode(Constants.BTN_CONFIRM_COLOR));
        btnSuaDV.setBackground(Color.decode(Constants.BTN_EDIT_COLOR));
        clearTextField();
        loadTable();
        unlockTextField(false);
      } else {
        JOptionPane.showMessageDialog(null, "Sửa dịch vụ thất bại");
      }
    }
  }

}