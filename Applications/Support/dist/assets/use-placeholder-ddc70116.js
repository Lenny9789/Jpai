import{r,s as n,e as h}from"./index-4ccc55cb.js";import{o as u}from"./on-popup-reopen-bcee1d9f.js";import{D as c,l,n as a,O as d,G as p}from"./index-3dcc8fbd.js";const f=(o,s)=>{const t=c(),e=()=>{t.value=h(o).height};return l(()=>{if(a(e),s)for(let i=1;i<=3;i++)setTimeout(e,100*i)}),u(()=>a(e)),d([r,n],e),t};function w(o,s){const t=f(o,!0);return e=>p("div",{class:s("placeholder"),style:{height:t.value?`${t.value}px`:void 0}},[e()])}export{w as u};