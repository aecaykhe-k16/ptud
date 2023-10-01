package ui;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Font;
import java.awt.GradientPaint;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.SQLException;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import javax.swing.AbstractAction;
import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;
import javax.swing.KeyStroke;
import javax.swing.border.Border;

import org.kordamp.ikonli.fontawesome5.FontAwesomeSolid;
import org.kordamp.ikonli.swing.FontIcon;

import bus.IDangNhapService;
import bus.implement.DangNhapImp;
import entities.NhanVien;
import entities.TaiKhoan;
import util.ConnectDB;
import util.Constants;
import util.SpecialButton;

public class ThongTinNguoiDung extends JFrame implements ActionListener {
  private JButton btnHinhAnh, btnBack, btnChangePass;
  private JLabel lblTen, lblNgaySinh, lblEmail, lblSDT, lblDiaChi, lblViTriCongViec, lblGioiTinh, lblMK;
  private JLabel txtNgaySinh, txtEmail, txtSDT, txtDiaChi, txtDiaChiBreak, txtGioiTinh;
  private JTextField txtChangePass;
  private JPasswordField txtMK;
  private JPanel pnlInfo;

  private Cursor handleCursor;
  private NhanVien nhanVien;
  private IDangNhapService dangNhap = new DangNhapImp();

  URL url = new URL(Constants.LOGO);
  Image imageIcon = new ImageIcon(url).getImage().getScaledInstance(100, 75, Image.SCALE_SMOOTH);
  private boolean isChangePass = false;
  private TaiKhoan tk;
  private String oldPass = "";

  public ThongTinNguoiDung(TaiKhoan taiKhoan) throws MalformedURLException {
    setTitle(Constants.APP_NAME);
    setSize(400, 440);
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
    tk = taiKhoan;
    nhanVien = dangNhap.getNV(taiKhoan.getEmail());
    pnlInfo = new JPanel() {
      @Override
      protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2d = (Graphics2D) g;
        g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        int w = getWidth(), h = getHeight();
        Color color1 = Color.decode("#3fb5fb");
        Color color2 = Color.decode("#ee4062");
        GradientPaint gp = new GradientPaint(0, 0, color1, w, h, color2);
        g2d.setPaint(gp);
        g2d.fillRect(0, 0, w, h);
      }

    };
    pnlInfo.setLayout(null);
    pnlInfo.setBounds(0, 0, 400, 440);
    pnlInfo.setBackground(Color.WHITE);
    add(pnlInfo);

    btnHinhAnh = new SpecialButton(100, null, null);
    btnHinhAnh.setIcon(FontIcon.of(FontAwesomeSolid.USER, 70, Color.BLACK));
    btnHinhAnh.setFont(new Font("Arial", Font.BOLD, 20));
    btnHinhAnh.setBounds(145, 10, 100, 100);
    btnHinhAnh.setBorderPainted(false);
    btnHinhAnh.setFocusPainted(false);
    btnHinhAnh.setContentAreaFilled(false);
    btnHinhAnh.setOpaque(false);
    pnlInfo.add(btnHinhAnh);

    lblTen = new JLabel(nhanVien.getTenNV());
    lblTen.setFont(new Font("Arial", Font.BOLD, 20));
    lblTen.setBounds(125, 120, 200, 30);
    pnlInfo.add(lblTen);

    lblViTriCongViec = new JLabel(nhanVien.getViTriCongViec());
    lblViTriCongViec.setFont(new Font("Arial", Font.PLAIN, 15));
    lblViTriCongViec.setBounds(165, 150, 200, 30);
    lblViTriCongViec.setForeground(Color.BLUE);
    pnlInfo.add(lblViTriCongViec);

    lblNgaySinh = new JLabel("Ngày sinh:");
    lblNgaySinh.setFont(new Font("Arial", Font.PLAIN, 15));
    lblNgaySinh.setBounds(40, 180, 100, 30);
    pnlInfo.add(lblNgaySinh);
    String formatNgaySinh = nhanVien.getNgaySinh().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    txtNgaySinh = new JLabel(formatNgaySinh);
    txtNgaySinh.setFont(new Font("Arial", Font.PLAIN, 15));
    txtNgaySinh.setBounds(140, 180, 250, 30);
    pnlInfo.add(txtNgaySinh);

    lblGioiTinh = new JLabel("Giới tính:");
    lblGioiTinh.setFont(new Font("Arial", Font.PLAIN, 15));
    lblGioiTinh.setBounds(40, 210, 100, 30);
    pnlInfo.add(lblGioiTinh);

    txtGioiTinh = new JLabel(nhanVien.getGioiTinh() ? "Nam" : "Nữ");
    txtGioiTinh.setFont(new Font("Arial", Font.PLAIN, 15));
    txtGioiTinh.setBounds(140, 210, 250, 30);
    pnlInfo.add(txtGioiTinh);

    lblSDT = new JLabel("SDT:");
    lblSDT.setFont(new Font("Arial", Font.PLAIN, 15));
    lblSDT.setBounds(40, 240, 100, 30);
    pnlInfo.add(lblSDT);

    txtSDT = new JLabel(nhanVien.getSdt());
    txtSDT.setFont(new Font("Arial", Font.PLAIN, 15));
    txtSDT.setBounds(140, 240, 250, 30);
    pnlInfo.add(txtSDT);

    lblEmail = new JLabel("Email:");
    lblEmail.setFont(new Font("Arial", Font.PLAIN, 15));
    lblEmail.setBounds(40, 270, 100, 30);
    pnlInfo.add(lblEmail);

    txtEmail = new JLabel(taiKhoan.getEmail());
    txtEmail.setFont(new Font("Arial", Font.PLAIN, 15));
    txtEmail.setBounds(140, 270, 250, 30);
    pnlInfo.add(txtEmail);

    lblDiaChi = new JLabel("Địa chỉ:");
    lblDiaChi.setFont(new Font("Arial", Font.PLAIN, 15));
    lblDiaChi.setBounds(40, 300, 100, 30);
    pnlInfo.add(lblDiaChi);

    String text = nhanVien.getDiaChi();
    String[] diaChi = text.split(" ");
    String[] primary = new String[5];
    List<String> secodary = new ArrayList<String>();
    for (int i = 0; i < diaChi.length; i++) {
      for (int j = 0; j < primary.length; j++) {
        if (primary[j] == null) {
          primary[j] = diaChi[i];
          break;
        }
      }
      if (i > 4) {
        secodary.add(diaChi[i]);
      }
    }
    String header = "";
    for (String string : primary) {
      if (string != null)
        header += string + " ";
    }
    txtDiaChi = new JLabel(header);
    txtDiaChi.setFont(new Font("Arial", Font.PLAIN, 15));
    txtDiaChi.setBounds(140, 300, 250, 30);
    pnlInfo.add(txtDiaChi);

    txtDiaChiBreak = new JLabel();
    txtDiaChiBreak.setFont(new Font("Arial", Font.PLAIN, 15));
    txtDiaChiBreak.setBounds(140, 330, 250, 30);
    pnlInfo.add(txtDiaChiBreak);
    String sub = "";
    for (String string : secodary) {
      sub += string + " ";
    }
    if (secodary.size() > 0) {
      txtDiaChiBreak.setText(sub);
    }

    lblMK = new JLabel("Mật khẩu:");
    lblMK.setFont(new Font("Arial", Font.PLAIN, 15));
    lblMK.setBounds(40, 360, 100, 30);
    pnlInfo.add(lblMK);

    txtMK = new JPasswordField(taiKhoan.getMatKhau());
    txtMK.setFont(new Font("Arial", Font.PLAIN, 15));
    txtMK.setBounds(140, 360, 150, 30);
    txtMK.setOpaque(false);
    txtMK.setBorder(null);
    txtMK.setBackground(getForeground());
    pnlInfo.add(txtMK);

    txtChangePass = new JTextField();
    txtChangePass.setBounds(140, 360, 150, 30);
    txtChangePass.setFont(new Font("Arial", Font.PLAIN, 15));
    txtChangePass.setOpaque(false);
    txtChangePass.setBackground(getForeground());
    Border border = BorderFactory.createMatteBorder(0, 0, 1, 0, Color.BLACK);
    txtChangePass.setBorder(border);

    btnChangePass = new JButton(FontIcon.of(FontAwesomeSolid.SYNC_ALT, 15));
    btnChangePass.setToolTipText("Đổi mật khẩu");
    btnChangePass.setBounds(300, 360, 30, 30);
    btnChangePass.setBorder(null);
    btnChangePass.setBorderPainted(false);
    btnChangePass.setContentAreaFilled(false);
    btnChangePass.setFocusPainted(false);
    btnChangePass.setOpaque(false);
    btnChangePass.setCursor(handleCursor);
    pnlInfo.add(btnChangePass);

    btnBack = new JButton();
    btnBack.setBorder(null);
    btnBack.setBorderPainted(false);
    btnBack.setContentAreaFilled(false);
    btnBack.setFocusPainted(false);
    btnBack.setOpaque(false);
    btnBack.setCursor(handleCursor);
    pnlInfo.add(btnBack);

    btnBack.addActionListener(this);
    btnChangePass.addActionListener(this);
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
    if (e.getSource() == btnBack)
      this.dispose();
    else if (e.getSource() == btnChangePass) {
      if (isChangePass == false) {
        String password = String.valueOf(txtMK.getPassword());
        FontIcon hiddenPass = FontIcon.of(FontAwesomeSolid.SAVE, 15);
        btnChangePass.setIcon(hiddenPass);
        pnlInfo.remove(txtMK);
        pnlInfo.add(txtChangePass);
        txtChangePass.setText(password);
        btnChangePass.setToolTipText("Lưu mật khẩu");
        oldPass = password;
        isChangePass = true;
      } else {
        String password = String.valueOf(txtChangePass.getText());
        int thongbao = JOptionPane.showConfirmDialog(null, "Bạn có muốn đổi mật khẩu không?", "Thông báo",
            JOptionPane.YES_NO_OPTION);
        if (thongbao == JOptionPane.YES_OPTION) {
          if (oldPass.equals(password)) {
            JOptionPane.showMessageDialog(null, "Mật khẩu mới không được trùng mật khẩu cũ");
            txtChangePass.requestFocus();
            return;
          } else {
            TaiKhoan taikhoan = new TaiKhoan(tk.getEmail(), password);
            if (dangNhap.doiMK(taikhoan)) {
              JOptionPane.showMessageDialog(null, "Đổi mật khẩu thành công");
              FontIcon showPassword = FontIcon.of(FontAwesomeSolid.SYNC_ALT, 15);
              btnChangePass.setIcon(showPassword);
              pnlInfo.remove(txtChangePass);
              pnlInfo.add(txtMK);
              btnChangePass.setToolTipText("Hiển thị mật khẩu");
              txtMK.setText(password);
              isChangePass = false;
            }
          }
        }
      }
    }

  }
}
