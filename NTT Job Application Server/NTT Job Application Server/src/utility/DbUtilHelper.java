package utility;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.commons.dbutils.QueryRunner;

/**
 * @author RuixingYang
 *
 */
/**
 * @author RuixingYang
 *
 */
public class DbUtilHelper {

	private static DataSource ds = null;
	
	public static QueryRunner getQueryRunner() {
		return new QueryRunner(ds);
	}

	public static Connection getConnection() {
		try {
			if (ds == null) {
				System.out.println("IMPORTANT: Static ds has been destroyed.");
				DbUtilHelper.initDatasource("java:comp/env/jdbc/nttDB");
			}
			return ds.getConnection();
		} catch (Exception e) {
			return null;
		}
	}
	
	public static void initDatasource(String nttDB) {
		try {
			ds = (DataSource) new InitialContext().lookup(nttDB);
		} catch (NamingException e) {
			log(e.getMessage());
		}
	}
	
	
	public static void log (String string){
		System.out.println("DbUtilHelper: " + string);
	}
	
}