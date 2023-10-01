package ui;

import static util.Constants.LOGO;
import static util.Constants.MAIN_FONT;
import static util.Constants.TITLE;
import static util.Constants.TITLE_COLOR;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.SQLException;

import javax.swing.AbstractAction;
import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.KeyStroke;
import javax.swing.border.Border;

import org.kordamp.ikonli.fontawesome5.FontAwesomeRegular;
import org.kordamp.ikonli.fontawesome5.FontAwesomeSolid;
import org.kordamp.ikonli.swing.FontIcon;

import bus.IDangNhapService;
import bus.implement.DangNhapImp;
import entities.TaiKhoan;
import util.ConnectDB;
import util.Constants;
import util.MyButton;
import util.PlaceholderPassword;
import util.PlaceholderTextField;

public class DangNhap extends JFrame implements ActionListener {

  private JLabel lblTaiKhoan;
  private JLabel lblMatKhau;
  private PlaceholderPassword txtMatKhau;
  private PlaceholderTextField txtTaiKhoan, txtMK;
  private JButton btnDangNhap, btnHienMatKhau;
  private JLabel lbTieuDe;
  private Cursor handleCursor;
  private IDangNhapService dangNhap = new DangNhapImp();
  private JPanel pnlChinh;
  private boolean flag = false;

  URL url = new URL(LOGO);
  Image imageIcon = new ImageIcon(url).getImage().getScaledInstance(100, 75, Image.SCALE_SMOOTH);
  URL img = new URL("https://res.cloudinary.com/kuga/image/upload/v1670335185/ptud/dangNhap_gihxko.png");
  Image image = new ImageIcon(img).getImage();

  public DangNhap() throws MalformedURLException {
    try {
      ConnectDB.getInstance().connect();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    gui();
  }

  private void gui() {
    this.setIconImage(imageIcon);
    this.setTitle("Đăng nhập");
    this.setDefaultCloseOperation(EXIT_ON_CLOSE);
    this.setMinimumSize(new Dimension(900, 550));
    this.setLocationRelativeTo(null);
    this.setResizable(false);
    this.setLayout(null);
    handleCursor = new Cursor(Cursor.HAND_CURSOR);
    pnlChinh = new JPanel() {
      @Override
      public void paintComponent(Graphics g) {
        super.paintComponent(g);
        g.drawImage(image, 0, 0, getWidth(), getHeight(), this);
      }
    };
    pnlChinh.setLayout(null);
    pnlChinh.setBounds(0, 0, 900, 600);
    pnlChinh.setBackground(Color.decode(Constants.MAIN_COLOR));
    pnlChinh.add(lbTieuDe = new JLabel(TITLE));
    Font f1 = new Font(MAIN_FONT, Font.BOLD, 70);
    lbTieuDe.setFont(f1);
    lbTieuDe.setForeground(Color.decode(TITLE_COLOR));
    lbTieuDe.setBounds(180, 20, 600, 150);

    pnlChinh.add(lblTaiKhoan = new JLabel(FontIcon.of(FontAwesomeSolid.USER, 30, Color.WHITE)));
    Font f2 = new Font(MAIN_FONT, 0, 25);
    lblTaiKhoan.setFont(f2);
    lblTaiKhoan.setForeground(Color.WHITE);
    lblTaiKhoan.setBounds(150, 210, 40, 40);

    txtTaiKhoan = new PlaceholderTextField(Color.decode("#EEF1FF"), true);
    txtTaiKhoan.setPlaceholder("Nhập tài khoản");
    txtTaiKhoan.setText("bichtuyenNV@gmail.com");
    txtTaiKhoan.setCaretColor(Color.WHITE);
    txtTaiKhoan.setBounds(220, 200, 550, 50);
    txtTaiKhoan.setForeground(Color.WHITE);
    txtTaiKhoan.setOpaque(false);
    Border tk = BorderFactory.createMatteBorder(0, 0, 1, 0, Color.WHITE);
    txtTaiKhoan.setBorder(tk);
    txtTaiKhoan.setFont(f2);
    txtTaiKhoan.requestFocus();
    pnlChinh.add(txtTaiKhoan);

    pnlChinh.add(lblMatKhau = new JLabel(FontIcon.of(FontAwesomeSolid.LOCK, 30, Color.WHITE)));
    lblMatKhau.setFont(f2);
    lblMatKhau.setForeground(Color.WHITE);
    lblMatKhau.setBounds(150, 310, 40, 40);

    txtMatKhau = new PlaceholderPassword(true);
    txtMatKhau.setText("123456");
    txtMatKhau.setPlaceholder("Nhập mật khẩu");
    txtMatKhau.setBounds(220, 300, 550, 50);
    txtMatKhau.setFont(f2);
    txtMatKhau.setCaretColor(Color.WHITE);
    txtMatKhau.setForeground(Color.WHITE);
    txtMatKhau.setOpaque(false);
    Border matKhau = BorderFactory.createMatteBorder(0, 0, 1, 0, Color.WHITE);
    txtMatKhau.setBorder(matKhau);
    pnlChinh.add(txtMatKhau);

    txtMK = new PlaceholderTextField(Color.decode("#EEF1FF"), true);
    txtMK.setPlaceholder("Nhập mật khẩu");
    txtMK.setBounds(220, 300, 550, 50);
    txtMK.setFont(f2);
    txtMK.setCaretColor(Color.WHITE);
    txtMK.setForeground(Color.WHITE);
    Border mk = BorderFactory.createMatteBorder(0, 0, 1, 0, Color.WHITE);
    txtMK.setOpaque(false);

    txtMK.setBorder(mk);

    btnDangNhap = new MyButton(20, Color.decode("#82CD47"), Color.decode("#82CD47"));
    btnDangNhap.setText("Đăng nhập");
    btnDangNhap.setFocusPainted(false);
    btnDangNhap.setBorderPainted(false);
    btnDangNhap.setCursor(handleCursor);
    btnDangNhap.setBounds(340, 400, 250, 40);
    btnDangNhap.setFont(f2);
    pnlChinh.add(btnDangNhap);
    btnDangNhap.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_ENTER, 0),
        "btnDangNhap");
    btnDangNhap.getActionMap().put("btnDangNhap", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnDangNhap.doClick();
      }
    });

    pnlChinh.add(btnHienMatKhau = new JButton(""));
    btnHienMatKhau.setBounds(780, 315, 50, 50);
    btnHienMatKhau.setBorder(null);
    btnHienMatKhau.setBackground(null);
    btnHienMatKhau.setToolTipText("Hiển thị mật khẩu");
    btnHienMatKhau.setCursor(handleCursor);

    FontIcon showPass = FontIcon.of(FontAwesomeSolid.EYE, 25, Color.WHITE);
    btnHienMatKhau.setIcon(showPass);
    btnHienMatKhau.setFocusPainted(false);
    btnHienMatKhau.setBorderPainted(false);
    btnHienMatKhau.setContentAreaFilled(false);

    this.add(pnlChinh);

    btnDangNhap.addActionListener(this);
    btnHienMatKhau.addActionListener(this);

  }

  @Override
  public void actionPerformed(ActionEvent arg0) {
    Object o = arg0.getSource();
    if (o.equals(btnDangNhap)) {
      String userName = txtTaiKhoan.getText();
      String password = "";
      if (txtMatKhau.getComponentCount() < 0) {
        password = txtMK.getText();
      } else {
        password = String.valueOf(txtMatKhau.getPassword());
      }
      if (userName == null || userName.isEmpty()) {
        JOptionPane.showMessageDialog(null, "Vui lòng nhập tài khoản");
        return;
      }
      if (password == null || password.isEmpty()) {
        JOptionPane.showMessageDialog(null, "Vui lòng nhập mật khẩu");
        return;
      }
      TaiKhoan taiKhoan = new TaiKhoan(userName, password, true);
      if (dangNhap.login(taiKhoan)) {
        JOptionPane.showMessageDialog(null, "Đăng nhập thành công");
        this.dispose();
        try {
          new QuanLyDatPhong(taiKhoan).setVisible(true);
        } catch (MalformedURLException e) {
          e.printStackTrace();
        }
      } else {
        JOptionPane.showMessageDialog(null, "Sai tên đăng nhập hoặc mật khẩu");
      }

    } else if (o.equals(btnHienMatKhau)) {
      if (flag == false) {
        String password = String.valueOf(txtMatKhau.getPassword());
        FontIcon hiddenPass = FontIcon.of(FontAwesomeRegular.EYE_SLASH, 25, Color.WHITE);
        btnHienMatKhau.setIcon(hiddenPass);
        pnlChinh.remove(txtMatKhau);
        pnlChinh.add(txtMK);
        txtMK.setText(password);
        btnHienMatKhau.setToolTipText("Ẩn mật khẩu");
        flag = true;
      } else {
        String password = String.valueOf(txtMK.getText());
        FontIcon showPassword = FontIcon.of(FontAwesomeRegular.EYE, 25, Color.WHITE);
        btnHienMatKhau.setIcon(showPassword);
        pnlChinh.remove(txtMK);
        pnlChinh.add(txtMatKhau);
        btnHienMatKhau.setToolTipText("Hiển thị mật khẩu");
        txtMatKhau.setText(password);
        flag = false;
      }
    }

  }
}