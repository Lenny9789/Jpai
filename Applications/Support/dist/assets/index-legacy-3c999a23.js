System.register(["./index-legacy-6518e8aa.js","./use-refs-legacy-1e7dfaf5.js","./mount-component-legacy-18eb38ea.js","./index-legacy-a073fbdb.js"],(function(e,a){"use strict";var o,t,l,r,n,i,s,c,d,u,v,f,p,h,m,g,b,y,_,w=document.createElement("style");return w.textContent=":root{--van-rate-icon-size: 20px;--van-rate-icon-gutter: var(--van-padding-base);--van-rate-icon-void-color: var(--van-gray-5);--van-rate-icon-full-color: var(--van-danger-color);--van-rate-icon-disabled-color: var(--van-gray-5)}.van-rate{display:inline-flex;cursor:pointer;-webkit-user-select:none;-moz-user-select:none;user-select:none;flex-wrap:wrap}.van-rate__item{position:relative}.van-rate__item:not(:last-child){padding-right:var(--van-rate-icon-gutter)}.van-rate__icon{display:block;width:1em;color:var(--van-rate-icon-void-color);font-size:var(--van-rate-icon-size)}.van-rate__icon--half{position:absolute;top:0;left:0;overflow:hidden;pointer-events:none}.van-rate__icon--full{color:var(--van-rate-icon-full-color)}.van-rate__icon--disabled{color:var(--van-rate-icon-disabled-color)}.van-rate--disabled{cursor:not-allowed}.van-rate--readonly{cursor:default}\n",document.head.appendChild(w),{setters:[e=>{o=e.c,t=e.n,l=e.m,r=e.a,n=e.t,i=e.b,s=e.u,c=e.d,d=e.I,u=e.e,v=e.p,f=e.f,p=e.w},e=>{h=e.u},e=>{m=e.u},e=>{g=e.C,b=e.D,y=e.N,_=e.G}],execute:function(){const[a,w]=o("rate"),x={size:t,icon:l("star"),color:String,count:r(5),gutter:t,clearable:Boolean,readonly:Boolean,disabled:Boolean,voidIcon:l("star-o"),allowHalf:Boolean,voidColor:String,touchable:n,iconPrefix:String,modelValue:i(0),disabledColor:String};var z=g({name:a,props:x,emits:["change","update:modelValue"],setup(e,{emit:a}){const o=m(),[t,l]=h(),r=b(),n=y((()=>e.readonly||e.disabled)),i=y((()=>n.value||!e.touchable)),p=y((()=>Array(+e.count).fill("").map(((a,o)=>function(e,a,o,t){if(e>=a)return{status:"full",value:1};if(e+.5>=a&&o&&!t)return{status:"half",value:.5};if(e+1>=a&&o&&t){const o=10**10;return{status:"half",value:Math.round((e-a+1)*o)/o}}return{status:"void",value:0}}(e.modelValue,o+1,e.allowHalf,e.readonly)))));let g,x,z=Number.MAX_SAFE_INTEGER,C=Number.MIN_SAFE_INTEGER;const E=()=>{x=u(r);const a=t.value.map(u);g=[],a.forEach(((a,o)=>{z=Math.min(a.top,z),C=Math.max(a.top,C),e.allowHalf?g.push({score:o+.5,left:a.left,top:a.top,height:a.height},{score:o+1,left:a.left+a.width/2,top:a.top,height:a.height}):g.push({score:o+1,left:a.left,top:a.top,height:a.height})}))},I=(a,o)=>{for(let e=g.length-1;e>0;e--)if(o>=x.top&&o<=x.bottom){if(a>g[e].left&&o>=g[e].top&&o<=g[e].top+g[e].height)return g[e].score}else{const t=o<x.top?z:C;if(a>g[e].left&&g[e].top===t)return g[e].score}return e.allowHalf?.5:1},S=o=>{n.value||o===e.modelValue||(a("update:modelValue",o),a("change",o))},V=e=>{i.value||(o.start(e),E())},H=(a,t)=>{const{icon:r,size:n,color:i,count:s,gutter:c,voidIcon:u,disabled:v,voidColor:p,allowHalf:h,iconPrefix:m,disabledColor:g}=e,b=t+1,y="full"===a.status,x="void"===a.status,z=h&&a.value>0&&a.value<1;let C;return c&&b!==+s&&(C={paddingRight:f(c)}),_("div",{key:t,ref:l(t),role:"radio",style:C,class:w("item"),tabindex:v?void 0:0,"aria-setsize":s,"aria-posinset":b,"aria-checked":!x,onClick:a=>{E();let t=h?I(a.clientX,a.clientY):b;e.clearable&&o.isTap.value&&t===e.modelValue&&(t=0),S(t)}},[_(d,{size:n,name:y?r:u,class:w("icon",{disabled:v,full:y}),color:v?g:y?i:p,classPrefix:m},null),z&&_(d,{size:n,style:{width:a.value+"em"},name:x?u:r,class:w("icon",["half",{disabled:v,full:!x}]),color:v?g:x?p:i,classPrefix:m},null)])};return s((()=>e.modelValue)),c("touchmove",(e=>{if(!i.value&&(o.move(e),o.isHorizontal()&&!o.isTap.value)){const{clientX:a,clientY:o}=e.touches[0];v(e),S(I(a,o))}}),{target:r}),()=>_("div",{ref:r,role:"radiogroup",class:w({readonly:e.readonly,disabled:e.disabled}),tabindex:e.disabled?void 0:0,"aria-disabled":e.disabled,"aria-readonly":e.readonly,onTouchstartPassive:V},[p.value.map(H)])}});e("R",p(z))}}}));