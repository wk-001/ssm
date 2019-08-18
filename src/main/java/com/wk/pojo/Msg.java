package com.wk.pojo;

import java.util.HashMap;
import java.util.Map;

/**
 * 通用的返回类
 */
public class Msg {

    //状态码
    private int code;

    //提示信息
    private String msg;

    //返回给浏览器的数据
    private Map<String,Object> extend = new HashMap<>();

    //链式调用
    public Msg add(String key,Object value){
        this.getExtend().put(key,value);
        return this;
    }

    public static Msg success(){
        Msg result = new Msg();
        result.setCode(1);
        result.setMsg("成功");
        return result;
    }

    public static Msg fail(){
        Msg result = new Msg();
        result.setCode(0);
        result.setMsg("失败");
        return result;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }
}
