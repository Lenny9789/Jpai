import{c as $,n as d,t as P,m as z,f as u,I as B,w as D}from"./index-4ccc55cb.js";import{C as j,D as f,p as C,N,a1 as _,O,a3 as R,a8 as U,l as q,n as b,G as n,a9 as F,aq as G,$ as S}from"./index-3dcc8fbd.js";const[M,t]=$("image"),T={src:String,alt:String,fit:String,position:String,round:Boolean,block:Boolean,width:d,height:d,radius:d,lazyLoad:Boolean,iconSize:d,showError:P,errorIcon:z("photo-fail"),iconPrefix:String,showLoading:P,loadingIcon:z("photo")};var V=j({name:M,props:T,emits:["load","error"],setup(a,{emit:v,slots:s}){const i=f(!1),o=f(!0),r=f(),{$Lazyload:l}=C().proxy,E=N(()=>{const e={width:u(a.width),height:u(a.height)};return _(a.radius)&&(e.overflow="hidden",e.borderRadius=u(a.radius)),e});O(()=>a.src,()=>{i.value=!1,o.value=!0});const g=e=>{o.value&&(o.value=!1,v("load",e))},m=()=>{const e=new Event("load");Object.defineProperty(e,"target",{value:r.value,enumerable:!0}),g(e)},h=e=>{i.value=!0,o.value=!1,v("error",e)},w=(e,c,I)=>I?I():n(B,{name:e,size:a.iconSize,class:c,classPrefix:a.iconPrefix},null),k=()=>{if(o.value&&a.showLoading)return n("div",{class:t("loading")},[w(a.loadingIcon,t("loading-icon"),s.loading)]);if(i.value&&a.showError)return n("div",{class:t("error")},[w(a.errorIcon,t("error-icon"),s.error)])},x=()=>{if(i.value||!a.src)return;const e={alt:a.alt,class:t("img"),style:{objectFit:a.fit,objectPosition:a.position}};return a.lazyLoad?F(n("img",S({ref:r},e),null),[[G("lazy"),a.src]]):n("img",S({ref:r,src:a.src,onLoad:g,onError:h},e),null)},y=({el:e})=>{const c=()=>{e===r.value&&o.value&&m()};r.value?c():b(c)},L=({el:e})=>{e===r.value&&!i.value&&h()};return l&&R&&(l.$on("loaded",y),l.$on("error",L),U(()=>{l.$off("loaded",y),l.$off("error",L)})),q(()=>{b(()=>{var e;(e=r.value)!=null&&e.complete&&!a.lazyLoad&&m()})}),()=>{var e;return n("div",{class:t({round:a.round,block:a.block}),style:E.value},[x(),k(),(e=s.default)==null?void 0:e.call(s)])}}});const J=D(V);export{J as I};
