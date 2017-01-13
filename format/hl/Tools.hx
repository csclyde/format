package format.hl;
import format.hl.Data;

class Tools {

	public static function isDynamic( t : HLType ) {
		return switch( t ) {
		case HVoid, HUi8, HUi16, HI32, HF32, HF64, HBool, HAt(_):
			false;
		case HBytes, HType, HRef(_), HAbstract(_), HEnum(_):
			false;
		case HDyn, HFun(_), HObj(_), HArray, HVirtual(_), HDynObj, HNull(_):
			true;
		}
	}

	public static function isPtr( t : HLType ) {
		return switch( t ) {
		case HVoid, HUi8, HUi16, HI32, HF32, HF64, HBool, HAt(_):
			false;
		case HBytes, HType, HRef(_), HAbstract(_), HEnum(_):
			true;
		case HDyn, HFun(_), HObj(_), HArray, HVirtual(_), HDynObj, HNull(_):
			true;
		}
	}

	public static function hash( name : String ) {
		var h = 0;
		for( i in 0...name.length )
			h = 223 * h + StringTools.fastCodeAt(name,i);
		h %= 0x1FFFFF7B;
		return h;
	}

	public static function toString( t : HLType ) {
		if( t == null )
			return "<null>";
		inline function fstr(t) {
			return switch(t) {
			case HFun(_): "(" + toString(t) + ")";
			default: toString(t);
			}
		};
		return switch( t ) {
		case HVoid: "Void";
		case HUi8: "hl.UI8";
		case HUi16: "hl.UI16";
		case HI32: "Int";
		case HF32: "Single";
		case HF64: "Float";
		case HBool: "Bool";
		case HBytes: "hl.Bytes";
		case HDyn: "Dynamic";
		case HFun(f):
			if( f.args.length == 0 ) "Void -> " + fstr(f.ret) else [for( a in f.args ) fstr(a)].join(" -> ") + " -> " + fstr(f.ret);
		case HObj(o):
			o.name;
		case HArray:
			"hl.NativeArray";
		case HType:
			"hl.Type";
		case HRef(t):
			"hl.Ref<" + toString(t) + ">";
		case HVirtual(fl):
			var fields = [for( f in fl ) { name : f.name, t : f.t }];
			for( f in fl ) f.t = HAt(0); // mark for recursion
			var str = "{ " + [for( f in fields ) f.name+" : " + toString(f.t)].join(", ") + " }";
			for( i in 0...fields.length ) fl[i].t = fields[i].t;
			str;
		case HDynObj:
			"hl.DynObj";
		case HAbstract(name):
			"hl.NativeAbstract<" + name+">";
		case HEnum(e):
			e.name;
		case HNull(t):
			"Null<" + toString(t) + ">";
		case HAt(_):
			"<...>";
		}
	}
}