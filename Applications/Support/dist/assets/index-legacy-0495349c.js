System.register(["./index-legacy-6518e8aa.js","./index-legacy-16749350.js","./index-legacy-a073fbdb.js"],(function(e,n){"use strict";var t,s,o,a,i,c,l,r,u,d,m,v,h=document.createElement("style");return h.textContent=":root{--van-count-down-text-color: var(--van-text-color);--van-count-down-font-size: var(--van-font-size-md);--van-count-down-line-height: var(--van-line-height-md)}.van-count-down{color:var(--van-count-down-text-color);font-size:var(--van-count-down-font-size);line-height:var(--van-count-down-line-height)}\n",document.head.appendChild(h),{setters:[e=>{t=e.y,s=e.c,o=e.a,a=e.m,i=e.t,c=e.z,l=e.w},e=>{r=e.u},e=>{u=e.C,d=e.N,m=e.O,v=e.G}],execute:function(){const[n,h]=s("count-down"),S={time:o(0),format:a("HH:mm:ss"),autoStart:i,millisecond:Boolean};var f=u({name:n,props:S,emits:["change","finish"],setup(e,{emit:n,slots:s}){const{start:o,pause:a,reset:i,current:l}=c({time:+e.time,millisecond:e.millisecond,onChange:e=>n("change",e),onFinish:()=>n("finish")}),u=d((()=>function(e,n){const{days:s}=n;let{hours:o,minutes:a,seconds:i,milliseconds:c}=n;if(e.includes("DD")?e=e.replace("DD",t(s)):o+=24*s,e.includes("HH")?e=e.replace("HH",t(o)):a+=60*o,e.includes("mm")?e=e.replace("mm",t(a)):i+=60*a,e.includes("ss")?e=e.replace("ss",t(i)):c+=1e3*i,e.includes("S")){const n=t(c,3);e=e.includes("SSS")?e.replace("SSS",n):e.includes("SS")?e.replace("SS",n.slice(0,2)):e.replace("S",n.charAt(0))}return e}(e.format,l.value))),S=()=>{i(+e.time),e.autoStart&&o()};return m((()=>e.time),S,{immediate:!0}),r({start:o,pause:a,reset:S}),()=>v("div",{role:"timer",class:h()},[s.default?s.default(l.value):u.value])}});e("C",l(f))}}}));