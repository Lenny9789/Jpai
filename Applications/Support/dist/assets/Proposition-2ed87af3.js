import{a as _}from"./runtime-dom.esm-bundler-65ecdaea.js";import{C as x,D as r,ad as d,E as h,R as e,G as l,a9 as m,w as p,Z as V,_ as C,o as g}from"./index-3dcc8fbd.js";import{R as k}from"./index-56bf55ac.js";import{C as P}from"./index-b73ef6b8.js";import"./index-6f49421e.js";import{N as U}from"./index-0b36e68f.js";import{_ as N,a as w,b as B}from"./ol3-83447a1c.js";import{r as c}from"./index-ec993ea9.js";import{a as u}from"./common-a47fff3e.js";import{_ as I}from"./_plugin-vue_export-helper-c27b6911.js";import"./index-4ccc55cb.js";import"./use-refs-a75f9fe4.js";import"./mount-component-74e25e35.js";import"./index-30732979.js";import"./constant-77ae5ca0.js";import"./on-popup-reopen-bcee1d9f.js";import"./use-placeholder-ddc70116.js";/* empty css              */import"./index-6db50d8f.js";import"./_commonjsHelpers-edff4021.js";const a=n=>(V("data-v-9813c033"),n=n(),C(),n),S={class:"proposition_box"},R=a(()=>e("div",{class:"spane"},null,-1)),T={class:"inp_box"},D=a(()=>e("div",{class:"inp_text"},"计划买入金额:",-1)),E={class:"payment_settings"},W={class:"paycord"},q={class:"payment_checkbox"},z=a(()=>e("img",{src:N,alt:"",class:"checked_img"},null,-1)),G=a(()=>e("img",{src:w,alt:"",class:"checked_img"},null,-1)),L=a(()=>e("img",{src:B,alt:"",class:"checked_img"},null,-1)),M={class:"additional_box"},O=a(()=>e("div",{class:"text_item"},"最低信誉",-1)),Z=a(()=>e("div",{class:"text_item"},"最低交易次数",-1)),j=x({__name:"Proposition",setup(n){r(),r(1),d({CN:"",WeChat_Url:"",PayPal_Url:""}),r();const o=d({plan_number:null,Credit:1,pay1:!1,pay2:!1,pay3:!1,transactions:0}),v=()=>{c.go(-1)},f=()=>{o.plan_number>0?o.pay1||o.pay2||o.pay3?c.push({path:"mate",query:{Sum:o.plan_number,PayPal:o.pay2?1:0,WeChat:o.pay1?1:0,UnionPay:o.pay3?1:0,Credit:Number(o.Credit)*100,NumberOfTrades:Number(o.transactions)}}):u({message:"请选择至少一种支付方式"}):u({message:"未填入计划购买金额"})};return(A,t)=>{const y=U,i=P,b=k;return g(),h("div",S,[e("div",null,[R,l(y,{title:"购买","left-text":"","left-arrow":"",onClickLeft:v})]),e("div",T,[D,e("div",null,[m(e("input",{type:"number",placeholder:"请输入计划购买的价格","onUpdate:modelValue":t[0]||(t[0]=s=>o.plan_number=s),class:"inp_cord"},null,512),[[_,o.plan_number]])])]),e("div",E,[e("div",W,[e("div",q,[l(i,{modelValue:o.pay1,"onUpdate:modelValue":t[1]||(t[1]=s=>o.pay1=s)},{default:p(()=>[z]),_:1},8,["modelValue"]),l(i,{modelValue:o.pay2,"onUpdate:modelValue":t[2]||(t[2]=s=>o.pay2=s)},{default:p(()=>[G]),_:1},8,["modelValue"]),l(i,{modelValue:o.pay3,"onUpdate:modelValue":t[3]||(t[3]=s=>o.pay3=s)},{default:p(()=>[L]),_:1},8,["modelValue"])])])]),e("div",M,[e("div",null,[O,e("div",null,[l(b,{modelValue:o.Credit,"onUpdate:modelValue":t[4]||(t[4]=s=>o.Credit=s),size:25,color:"#ffd21e","void-icon":"star","void-color":"#eee"},null,8,["modelValue"])])]),e("div",null,[Z,m(e("input",{type:"number","onUpdate:modelValue":t[5]||(t[5]=s=>o.transactions=s),placeholder:"卖家最低交易次数",class:"low_number_box"},null,512),[[_,o.transactions]])])]),e("div",{class:"btn_box"},[e("button",{class:"btn",onClick:f},"开始购买")])])}}});const co=I(j,[["__scopeId","data-v-9813c033"]]);export{co as default};