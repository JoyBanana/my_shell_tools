#!/usr/bin/env python3

import requests
import json
import sys

#please touch logfile=send_wechat.log and tokenfile=access_token
corpid=""
corpsecret=""


def send_msg(message):
    #what the parameter mean? to read https://work.weixin.qq.com/api/doc#90000/90135/90236
    #mMessage_data={"toparty":"2","msgtype":"text","agentid":1000002,"text":{"content":message}}
    mMsg="{\"toparty\":\"2\",\"msgtype\":\"text\",\"agentid\":1000002,\"text\":{\"content\":\""+message+"\"}}"
    send_msg_url="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token="
    mMsg=mMsg.encode('utf-8')
    #tran to str
    #mMsg=json.dumps(mMessage_data)
    #build POST data
    req_send_msg=requests.post(send_msg_url+get_access_key(),mMsg)
    rep=req_send_msg.json()
    #Get the KEY from internet and resend MSG when error occurs,because it's maybe KEY error
    if rep["errcode"] != 0 :
        write_log("[MSG]: errcode!=0 ,server said:"+json.dumps(rep)+"\nupdateKEY and resend")
        a=send_msg_url+get_access_key_from_internet()
        req_send_msg=requests.post(a,mMsg)
        rep=req_send_msg.json()
    #print("[MSG]: the server said:\n"+json.dumps(rep)+"\n")
    write_log("[MSG]: the server said:"+json.dumps(rep))

#get KEY from internet and write to file if it's null
def get_access_key_from_internet():
    current_script_path=sys.path[0]
    with open(current_script_path+'/access_token', 'w+', encoding='utf-8') as f:
        ac_token_url="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid="+corpid+"&corpsecret="+corpsecret
        response = requests.get(ac_token_url)
        access_token=response.json()["access_token"]
        #print('update KEY :  '+access_token)
        f.write(access_token)
        return access_token
    return access_token


def get_access_key():
    #read KEY from current dir
    current_script_path=sys.path[0]
    #print("current PATH IS "+ current_script_path)
    with open(current_script_path+'/access_token', 'r', encoding='utf-8') as f:
        access_token=f.read()
        #print("read KEY from loacl is : "+access_token)
        if access_token == '':
            return get_access_key_from_internet()
        return access_token

def write_log(message):
    with open(sys.path[0]+"/send_wechat.log","a") as f:
        f.write(message+'\n')

m_msg=sys.argv[1]
write_log(m_msg)
send_msg(m_msg)
