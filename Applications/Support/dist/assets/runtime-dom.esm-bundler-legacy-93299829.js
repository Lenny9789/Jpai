System.register(["./index-legacy-a073fbdb.js"],(function(e,t){"use strict";var n,r,o,i,s,l,a,c,u,p,f,m,v,d,g,h,b,y,C,S,A,E,T,_;return{setters:[e=>{n=e.e,r=e.B,o=e.i,i=e.b,s=e.d,l=e.t,a=e.h,c=e.f,u=e.g,p=e.j,f=e.k,m=e.l,v=e.m,d=e.p,g=e.F,h=e.S,b=e.q,y=e.s,C=e.u,S=e.v,A=e.x,E=e.y,T=e.z,_=e.A}],execute:function(){e("u",(function(e){const t=d();if(!t)return;const n=()=>z(t.subTree,e(t.proxy));f(n),m((()=>{const e=new MutationObserver(n);e.observe(t.subTree.el.parentNode,{childList:!0}),v((()=>e.disconnect()))}))}));const t="undefined"!=typeof document?document:null,w=t&&t.createElement("template"),x={insert:(e,t,n)=>{t.insertBefore(e,n||null)},remove:e=>{const t=e.parentNode;t&&t.removeChild(e)},createElement:(e,n,r,o)=>{const i=n?t.createElementNS("http://www.w3.org/2000/svg",e):t.createElement(e,r?{is:r}:void 0);return"select"===e&&o&&null!=o.multiple&&i.setAttribute("multiple",o.multiple),i},createText:e=>t.createTextNode(e),createComment:e=>t.createComment(e),setText:(e,t)=>{e.nodeValue=t},setElementText:(e,t)=>{e.textContent=t},parentNode:e=>e.parentNode,nextSibling:e=>e.nextSibling,querySelector:e=>t.querySelector(e),setScopeId(e,t){e.setAttribute(t,"")},insertStaticContent(e,t,n,r,o,i){const s=n?n.previousSibling:t.lastChild;if(o&&(o===i||o.nextSibling))for(;t.insertBefore(o.cloneNode(!0),n),o!==i&&(o=o.nextSibling););else{w.innerHTML=r?`<svg>${e}</svg>`:e;const o=w.content;if(r){const e=o.firstChild;for(;e.firstChild;)o.appendChild(e.firstChild);o.removeChild(e)}t.insertBefore(o,n)}return[s?s.nextSibling:t.firstChild,n?n.previousSibling:t.lastChild]}},L=/\s*!important$/;function N(e,t,n){if(u(n))n.forEach((n=>N(e,t,n)));else if(null==n&&(n=""),t.startsWith("--"))e.setProperty(t,n);else{const r=function(e,t){const n=B[t];if(n)return n;let r=S(t);if("filter"!==r&&r in e)return B[t]=r;r=A(r);for(let o=0;o<P.length;o++){const n=P[o]+r;if(n in e)return B[t]=n}return t}(e,t);L.test(n)?e.setProperty(b(r),n.replace(L,""),"important"):e[r]=n}}const P=["Webkit","Moz","ms"],B={},$="http://www.w3.org/1999/xlink";function F(e,t,n,r){e.addEventListener(t,n,r)}function M(e,t,n,r,o=null){const i=e._vei||(e._vei={}),s=i[t];if(r&&s)s.value=r;else{const[n,l]=function(e){let t;if(k.test(e)){let n;for(t={};n=e.match(k);)e=e.slice(0,e.length-n[0].length),t[n[0].toLowerCase()]=!0}const n=":"===e[2]?e.slice(3):b(e.slice(2));return[n,t]}(t);if(r){const s=i[t]=function(e,t){const n=e=>{if(e._vts){if(e._vts<=n.attached)return}else e._vts=Date.now();_(function(e,t){if(u(t)){const n=e.stopImmediatePropagation;return e.stopImmediatePropagation=()=>{n.call(e),e._stopped=!0},t.map((e=>t=>!t._stopped&&e&&e(t)))}return t}(e,n.value),t,5,[e])};return n.value=e,n.attached=I(),n}(r,o);F(e,n,s,l)}else s&&(function(e,t,n,r){e.removeEventListener(t,n,r)}(e,n,s,l),i[t]=void 0)}}const k=/(?:Once|Passive|Capture)$/;let D=0;const H=Promise.resolve(),I=()=>D||(H.then((()=>D=0)),D=Date.now()),q=/^on[a-z]/;function z(e,t){if(128&e.shapeFlag){const n=e.suspense;e=n.activeBranch,n.pendingBranch&&!n.isHydrating&&n.effects.push((()=>{z(n.activeBranch,t)}))}for(;e.component;)e=e.component.subTree;if(1&e.shapeFlag&&e.el)O(e.el,t);else if(e.type===g)e.children.forEach((e=>z(e,t)));else if(e.type===h){let{el:n,anchor:r}=e;for(;n&&(O(n,t),n!==r);)n=n.nextSibling}}function O(e,t){if(1===e.nodeType){const n=e.style;for(const e in t)n.setProperty(`--${e}`,t[e])}}const V="transition",K="animation",j=e("T",((e,{slots:t})=>a(r,function(e){const t={};for(const n in e)n in U||(t[n]=e[n]);if(!1===e.css)return t;const{name:r="v",type:o,duration:i,enterFromClass:s=`${r}-enter-from`,enterActiveClass:l=`${r}-enter-active`,enterToClass:a=`${r}-enter-to`,appearFromClass:u=s,appearActiveClass:p=l,appearToClass:f=a,leaveFromClass:m=`${r}-leave-from`,leaveActiveClass:v=`${r}-leave-active`,leaveToClass:d=`${r}-leave-to`}=e,g=function(e){if(null==e)return null;if(c(e))return[G(e.enter),G(e.leave)];{const t=G(e);return[t,t]}}(i),h=g&&g[0],b=g&&g[1],{onBeforeEnter:y,onEnter:C,onEnterCancelled:S,onLeave:A,onLeaveCancelled:E,onBeforeAppear:T=y,onAppear:_=C,onAppearCancelled:w=S}=t,x=(e,t,n)=>{J(e,t?f:a),J(e,t?p:l),n&&n()},L=(e,t)=>{e._isLeaving=!1,J(e,m),J(e,d),J(e,v),t&&t()},N=e=>(t,n)=>{const r=e?_:C,i=()=>x(t,e,n);R(r,[t,i]),Q((()=>{J(t,e?u:s),X(t,e?f:a),W(r)||Z(t,o,h,i)}))};return n(t,{onBeforeEnter(e){R(y,[e]),X(e,s),X(e,l)},onBeforeAppear(e){R(T,[e]),X(e,u),X(e,p)},onEnter:N(!1),onAppear:N(!0),onLeave(e,t){e._isLeaving=!0;const n=()=>L(e,t);X(e,m),document.body.offsetHeight,X(e,v),Q((()=>{e._isLeaving&&(J(e,m),X(e,d),W(A)||Z(e,o,b,n))})),R(A,[e,n])},onEnterCancelled(e){x(e,!1),R(S,[e])},onAppearCancelled(e){x(e,!0),R(w,[e])},onLeaveCancelled(e){L(e),R(E,[e])}})}(e),t)));j.displayName="Transition";const U={name:String,type:String,css:{type:Boolean,default:!0},duration:[String,Number,Object],enterFromClass:String,enterActiveClass:String,enterToClass:String,appearFromClass:String,appearActiveClass:String,appearToClass:String,leaveFromClass:String,leaveActiveClass:String,leaveToClass:String};j.props=n({},r.props,U);const R=(e,t=[])=>{u(e)?e.forEach((e=>e(...t))):e&&e(...t)},W=e=>!!e&&(u(e)?e.some((e=>e.length>1)):e.length>1);function G(e){return l(e)}function X(e,t){t.split(/\s+/).forEach((t=>t&&e.classList.add(t))),(e._vtc||(e._vtc=new Set)).add(t)}function J(e,t){t.split(/\s+/).forEach((t=>t&&e.classList.remove(t)));const{_vtc:n}=e;n&&(n.delete(t),n.size||(e._vtc=void 0))}function Q(e){requestAnimationFrame((()=>{requestAnimationFrame(e)}))}let Y=0;function Z(e,t,n,r){const o=e._endId=++Y,i=()=>{o===e._endId&&r()};if(n)return setTimeout(i,n);const{type:s,timeout:l,propCount:a}=function(e,t){const n=window.getComputedStyle(e),r=e=>(n[e]||"").split(", "),o=r(V+"Delay"),i=r(V+"Duration"),s=ee(o,i),l=r(K+"Delay"),a=r(K+"Duration"),c=ee(l,a);let u=null,p=0,f=0;t===V?s>0&&(u=V,p=s,f=i.length):t===K?c>0&&(u=K,p=c,f=a.length):(p=Math.max(s,c),u=p>0?s>c?V:K:null,f=u?u===V?i.length:a.length:0);const m=u===V&&/\b(transform|all)(,|$)/.test(n[V+"Property"]);return{type:u,timeout:p,propCount:f,hasTransform:m}}(e,t);if(!s)return r();const c=s+"end";let u=0;const p=()=>{e.removeEventListener(c,f),i()},f=t=>{t.target===e&&++u>=a&&p()};setTimeout((()=>{u<a&&p()}),l+1),e.addEventListener(c,f)}function ee(e,t){for(;e.length<t.length;)e=e.concat(e);return Math.max(...t.map(((t,n)=>te(t)+te(e[n]))))}function te(e){return 1e3*Number(e.slice(0,-1).replace(",","."))}const ne=e=>{const t=e.props["onUpdate:modelValue"]||!1;return u(t)?e=>p(t,e):t};function re(e){e.target.composing=!0}function oe(e){const t=e.target;t.composing&&(t.composing=!1,t.dispatchEvent(new Event("input")))}e("a",{created(e,{modifiers:{lazy:t,trim:n,number:r}},o){e._assign=ne(o);const i=r||o.props&&"number"===o.props.type;F(e,t?"change":"input",(t=>{if(t.target.composing)return;let r=e.value;n&&(r=r.trim()),i&&(r=l(r)),e._assign(r)})),n&&F(e,"change",(()=>{e.value=e.value.trim()})),t||(F(e,"compositionstart",re),F(e,"compositionend",oe),F(e,"change",oe))},mounted(e,{value:t}){e.value=null==t?"":t},beforeUpdate(e,{value:t,modifiers:{lazy:n,trim:r,number:o}},i){if(e._assign=ne(i),e.composing)return;if(document.activeElement===e&&"range"!==e.type){if(n)return;if(r&&e.value.trim()===t)return;if((o||"number"===e.type)&&l(e.value)===t)return}const s=null==t?"":t;e.value!==s&&(e.value=s)}});const ie=["ctrl","shift","alt","meta"],se={stop:e=>e.stopPropagation(),prevent:e=>e.preventDefault(),self:e=>e.target!==e.currentTarget,ctrl:e=>!e.ctrlKey,shift:e=>!e.shiftKey,alt:e=>!e.altKey,meta:e=>!e.metaKey,left:e=>"button"in e&&0!==e.button,middle:e=>"button"in e&&1!==e.button,right:e=>"button"in e&&2!==e.button,exact:(e,t)=>ie.some((n=>e[`${n}Key`]&&!t.includes(n)))},le=(e("b",((e,t)=>(n,...r)=>{for(let e=0;e<t.length;e++){const r=se[t[e]];if(r&&r(n,t))return}return e(n,...r)})),{esc:"escape",space:" ",up:"arrow-up",left:"arrow-left",right:"arrow-right",down:"arrow-down",delete:"backspace"});function ae(e,t){e.style.display=t?e._vod:"none"}e("w",((e,t)=>n=>{if(!("key"in n))return;const r=b(n.key);return t.some((e=>e===r||le[e]===r))?e(n):void 0})),e("v",{beforeMount(e,{value:t},{transition:n}){e._vod="none"===e.style.display?"":e.style.display,n&&t?n.beforeEnter(e):ae(e,t)},mounted(e,{value:t},{transition:n}){n&&t&&n.enter(e)},updated(e,{value:t,oldValue:n},{transition:r}){!t!=!n&&(r?t?(r.beforeEnter(e),ae(e,!0),r.enter(e)):r.leave(e,(()=>{ae(e,!1)})):ae(e,t))},beforeUnmount(e,{value:t}){ae(e,t)}});const ce=n({patchProp:(e,t,n,r,s=!1,l,a,c,u)=>{"class"===t?function(e,t,n){const r=e._vtc;r&&(t=(t?[t,...r]:[...r]).join(" ")),null==t?e.removeAttribute("class"):n?e.setAttribute("class",t):e.className=t}(e,r,s):"style"===t?function(e,t,n){const r=e.style,o=i(n);if(n&&!o){for(const e in n)N(r,e,n[e]);if(t&&!i(t))for(const e in t)null==n[e]&&N(r,e,"")}else{const i=r.display;o?t!==n&&(r.cssText=n):t&&e.removeAttribute("style"),"_vod"in e&&(r.display=i)}}(e,n,r):y(t)?C(t)||M(e,t,0,r,a):("."===t[0]?(t=t.slice(1),1):"^"===t[0]?(t=t.slice(1),0):function(e,t,n,r){return r?"innerHTML"===t||"textContent"===t||!!(t in e&&q.test(t)&&o(n)):"spellcheck"!==t&&"draggable"!==t&&"translate"!==t&&("form"!==t&&(("list"!==t||"INPUT"!==e.tagName)&&(("type"!==t||"TEXTAREA"!==e.tagName)&&((!q.test(t)||!i(n))&&t in e))))}(e,t,r,s))?function(e,t,n,r,o,i,s){if("innerHTML"===t||"textContent"===t)return r&&s(r,o,i),void(e[t]=null==n?"":n);if("value"===t&&"PROGRESS"!==e.tagName&&!e.tagName.includes("-")){e._value=n;const r=null==n?"":n;return e.value===r&&"OPTION"!==e.tagName||(e.value=r),void(null==n&&e.removeAttribute(t))}let l=!1;if(""===n||null==n){const r=typeof e[t];"boolean"===r?n=T(n):null==n&&"string"===r?(n="",l=!0):"number"===r&&(n=0,l=!0)}try{e[t]=n}catch(a){}l&&e.removeAttribute(t)}(e,t,r,l,a,c,u):("true-value"===t?e._trueValue=r:"false-value"===t&&(e._falseValue=r),function(e,t,n,r,o){if(r&&t.startsWith("xlink:"))null==n?e.removeAttributeNS($,t.slice(6,t.length)):e.setAttributeNS($,t,n);else{const r=E(t);null==n||r&&!T(n)?e.removeAttribute(t):e.setAttribute(t,r?"":n)}}(e,t,r,s))}},x);let ue;e("c",((...e)=>{const t=(ue||(ue=s(ce))).createApp(...e),{mount:n}=t;return t.mount=e=>{const r=function(e){return i(e)?document.querySelector(e):e}(e);if(!r)return;const s=t._component;o(s)||s.render||s.template||(s.template=r.innerHTML),r.innerHTML="";const l=n(r,!1,r instanceof SVGElement);return r instanceof Element&&(r.removeAttribute("v-cloak"),r.setAttribute("data-v-app","")),l},t}))}}}));
