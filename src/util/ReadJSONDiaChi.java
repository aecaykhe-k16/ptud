package util;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

public class ReadJSONDiaChi {
  private JSONArray treeAddress;
  private JSONObject tinhChon;

  public ReadJSONDiaChi() {
    JSONParser parser = new JSONParser();

    try {
      Reader reader = new FileReader("data\\dvhcvn.json");
      treeAddress = (JSONArray) parser.parse(reader);
    } catch (FileNotFoundException e) {
      throw new RuntimeException(e);
    } catch (IOException e) {
      throw new RuntimeException(e);
    } catch (ParseException e) {
      throw new RuntimeException(e);
    }
  }

  public List<String> getDSTinh() {
    List<String> dsTinh = new ArrayList<>();
    for (Object it : treeAddress) {
      JSONObject tmp = (JSONObject) it;
      dsTinh.add(tmp.get("name").toString());
    }
    return dsTinh;
  }

  public List<String> getDSHuyen(String tenTinh) {
    List<String> dsHuyen = new ArrayList<>();
    for (Object it : treeAddress) {
      JSONObject tmp = (JSONObject) it;
      if (tmp.get("name").equals(tenTinh)) {
        JSONArray JSdsHuyen = (JSONArray) tmp.get("level2s");
        for (Object it1 : JSdsHuyen) {
          JSONObject tmp2 = (JSONObject) it1;
          dsHuyen.add(tmp2.get("name").toString());
        }
        tinhChon = (JSONObject) it;
        break;
      }
    }
    return dsHuyen;
  }

  public List<String> getDSXa(String tenHuyen) {
    List<String> dsXa = new ArrayList<>();
    for (Object it : (JSONArray) tinhChon.get("level2s")) {
      JSONObject tmp = (JSONObject) it;
      if (tmp.get("name").equals(tenHuyen)) {
        JSONArray JSdsHuyen = (JSONArray) tmp.get("level3s");
        for (Object it1 : JSdsHuyen) {
          JSONObject tmp2 = (JSONObject) it1;
          dsXa.add(tmp2.get("name").toString());
        }
      }
    }
    return dsXa;
  }

}
