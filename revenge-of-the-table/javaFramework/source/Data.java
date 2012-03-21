// Michael Vitrano and Jared Pochtar

package rtlib;

import java.util.Date;
import java.text.SimpleDateFormat;

public class Data {
	
	public static final int INT_TYPE = 1;
	public static final int FLOAT_TYPE = 2;
	public static final int STRING_TYPE = 3;
	public static final int BOOL_TYPE = 4;
	public static final int DATE_TYPE = 5;
    public int _Integer;
	public double _Float;
	public String _String;
	public boolean _Bool;
	public Date _Date;
	private int type;
	
	
	/* Encapsulates the basic data types. Constructor knows which type
	 * is correct.
	 * 
	 */
	public Data(String aString){
		try{
			SimpleDateFormat format = new SimpleDateFormat();
			_Date = format.parse(aString);
			type = DATE_TYPE;
		}catch(Exception e){
			_String = aString;
			type = STRING_TYPE;
		}
	}
	
	public Data(int anInt){
		_Integer = anInt;
		type = INT_TYPE;
	}
	
	public Data(double aFloat){
		_Float = aFloat;
		type = FLOAT_TYPE;
	}
	
	public Data(boolean aBool){
		_Bool = aBool;
		type = BOOL_TYPE;
	}
	
	public int getType(){
		return type;
	}
	
	public String getString(){
			return _String;
	}
	
	public int getInt(){
			return _Integer;
	}
	
	public double getFloat(){
			return _Float;
	}
	
	public boolean getBool(){
			return _Bool;
	}
	
	public boolean equalTo(Data other){
		if(other.type == INT_TYPE)
			return this._Integer == other._Integer;
		else if(other.type == STRING_TYPE)
			return this._String.equals(other._String);
		else if(other.type == BOOL_TYPE)
			return this._Bool == other._Bool;
		else if (other.type == FLOAT_TYPE)
			return this._Float == other._Float;		
		else
			return this._Date.equals(other._Date);
	}
	
	public String toString(){
		if(type == INT_TYPE)
			return ""+_Integer;
		if(type == STRING_TYPE)
			return _String;
		if(type == FLOAT_TYPE)
			return ""+_Float;
		if(type == FLOAT_TYPE)
			return ""+_Bool;
		return _Date.toString();
	}
	
	public Data copyOf(){
		if(type == INT_TYPE)
			return new Data(_Integer);
		else if(type == STRING_TYPE)
			return new Data(new String(_String));
		else if(type == BOOL_TYPE)
			return new Data(_Bool);
		else if(type == FLOAT_TYPE)
			return new Data(_Float);
		else
			return new Data(_Date.toString());
	}
	
}
