#!/usr/bin/env node
"use strict";

/* theme-kitchen-sink.ts
   Purpose: exhaustively exercise editor syntax scopes for the Bliss Neovim theme.

   Includes:
   - shebang, pragma, comments (line/block/doc)
   - imports/exports, type-only imports
   - enums, interfaces, types (unions/intersections/tuples/conditional/mapped/template-literal)
   - classes (abstract, decorators, generics, access modifiers, private #fields, static, getters/setters)
   - functions (overloads, generics, async/await, generator, rest/spread, default params)
   - variables (const/let/var), destructuring, as const, satisfies
   - numbers (int/float/hex/oct/bin/BigInt, numeric separators)
   - strings (single/double/backtick, template/tagged, raw, unicode, escapes)
   - regex literals (named groups, flags)
   - operators (arith/logical/bitwise/ternary/optional chaining/nullish coalescing)
   - control flow (if/else, switch, loops, labels, break/continue)
   - try/catch/finally, throw, Error subclass
   - Map/Set/WeakMap/WeakSet, Symbol, Proxy, Reflect, Date, Math
   - namespace, declare module (ambient), JSDoc, region markers, debugger
*/

// TODO: ...
// FIXME: ...

//#region Imports
import fs from "node:fs";
import path from "node:path";
import type { Readable } from "node:stream";
//#endregion

//#region Types & Interfaces
/** User role */
export enum Role {
  Guest = 0,
  User = 1,
  Admin = 2,
}

/** Basic user object */
export interface User {
  readonly id: number;
  name: string;
  email?: string | null;
  role: Role | "owner";
}

/** Generic Maybe type */
export type Maybe<T> = T | null | undefined;

/** Tuple and union/intersection samples */
export type Point = readonly [x: number, y: number];
export type IO = "stdin" | "stdout" | "stderr";
export type WithMeta<T> = T & { meta?: Record<string, unknown> };

/** Conditional + infer */
export type Awaited<T> = T extends Promise<infer U> ? U : T;

/** Mapped type */
export type PartialRecord<K extends string, T> = { [P in K]?: T };

/** Template literal type */
export type EventName = `on${Capitalize<string>}`;

/** Const assertion + satisfies (TS 4.9+) */
export const THEME_DEFAULTS = {
  foreground: "#EEEAF1",
  muted: "#BBB4BE",
  background: "#1E1A24",
} as const satisfies Record<string, string>;
//#endregion

//#region Ambient declaration (won't run, exercises scopes)
/* eslint-disable @typescript-eslint/triple-slash-reference */
declare module "acme:virtual" {
  export function hello(name: string): string;
}
//#endregion

//#region Decorators
function sealed<T extends { new (...args: any[]): {} }>(ctor: T) {
  Object.seal(ctor);
  Object.seal(ctor.prototype);
}
function enumerable(value: boolean) {
  return (_t: any, _k: string, d: PropertyDescriptor) => {
    d.enumerable = value;
  };
}
//#endregion

//#region Classes
abstract class BaseError extends Error {
  constructor(message: string) {
    super(message);
    this.name = new.target.name;
  }
}

@sealed
class Vector2 {
  #x = 0; // private field
  #y = 0;
  static ZERO = new Vector2(0, 0);
  constructor(x = 0, y = 0) {
    this.#x = x;
    this.#y = y;
  }
  get x() {
    return this.#x;
  }
  set x(v: number) {
    this.#x = v | 0;
  } // bitwise op
  get y() {
    return this.#y;
  }
  set y(v: number) {
    this.#y = v | 0;
  }

  @enumerable(true)
  length(): number {
    return Math.hypot(this.#x, this.#y);
  }

  add({ x, y }: { x: number; y: number }): Vector2 {
    return new Vector2(this.#x + x, this.#y + y);
  }
}

class Box<T> {
  #value: T;
  constructor(v: T) {
    this.#value = v;
  }
  map<U>(fn: (v: T) => U): Box<U> {
    return new Box(fn(this.#value));
  }
}
//#endregion

//#region Functions (overloads, generators, async, tagged literals)
/** Sum overloads */
export function sum(a: number, b: number): number;
export function sum(a: string, b: string): string;
export function sum(a: any, b: any) {
  return a + b;
}

export function* idGen(seed = 0): Generator<number, void, unknown> {
  let i = seed;
  while (true) {
    yield i++;
  }
}

export async function readText(p: string): Promise<string> {
  const buf = await fs.promises.readFile(p);
  return buf.toString("utf8");
}

// Tagged template literal
function sql(strings: TemplateStringsArray, ...vals: any[]) {
  // Raw shows escapes untouched:
  const raw = strings.raw[0];
  return raw.replace(/\$(\d+)/g, (_, i) =>
    String(vals[Number(i) - 1] ?? "NULL"),
  );
}

const userId = 42;
const QUERY = sql`SELECT * FROM users WHERE id = ${userId};`;
//#endregion

//#region Regex / Numbers / Strings
const RE_DATE = /(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/giu;

const dec = 1234;
const floaty = 3.141_592_653;
const hex = 0xff_ff;
const oct = 0o7_55;
const bin = 0b1010_1100;
const big: bigint = 9_223_372_036_854_775_807n;

const single = "sakura \u2665";
const dbl = "leaf\t\u{1F331}";
const back = `berry-${userId}-${dec}`;
const raw = String.raw`\n not escaped \t \u00A9`;
const multiline = `line1
line2
line3`;
//#endregion

//#region Operators / Control flow / Labels
let maybe: Maybe<number> = null;
const v = maybe ?? 99; // nullish coalescing
const opt = ({ a }: any) => a?.b?.c ?? "na"; // optional chaining

let acc = 0;
for (let i = 0; i < 5; i++) acc += i;

outer: for (const ch of ["a", "b", "c"]) {
  if (ch === "b") continue outer;
}

switch (
  hex & 0xf // bitwise AND
) {
  case 0xf:
    acc ^= 1;
    break; // XOR
  default:
    acc <<= 1; // shift
}

try {
  if (!RE_DATE.test("2025-11-01")) throw new BaseError("Bad date");
} catch (e) {
  console.warn("caught", (e as Error).message);
} finally {
  // cleanup
}
//#endregion

//#region Destructuring / Rest/Spread / Maps/Sets
const point: Point = [10, 20] as const;
const [px, py] = point;
const obj = { px, py, role: Role.Admin, meta: { sakura: true } };
const clone = { ...obj, px: 11, extra: ["x", ..."yz"] };

const map = new Map<string, number>([["a", 1]]);
const set = new Set([1, 2, 3]);
const weakMap = new WeakMap<object, number>();
const weakSet = new WeakSet<object>();
weakMap.set(obj, 99);
weakSet.add(obj);

const sym = Symbol("tag");
const fancy = { [sym]: "ok", [Symbol.toStringTag]: "Fancy" };

const proxy = new Proxy(fancy, {
  get(target, prop, receiver) {
    return Reflect.get(target, prop, receiver);
  },
});

// Debugger statement to light that token:
debugger;
//#endregion

//#region Namespaces (legacy but useful for theming)
namespace Maths {
  export const tau = Math.PI * 2;
  export function clamp(n: number, lo: number, hi: number) {
    return Math.min(hi, Math.max(lo, n));
  }
}
//#endregion

//#region Generators / Async iterator
async function* lines(r: Readable): AsyncGenerator<string> {
  for await (const chunk of r) {
    yield String(chunk);
  }
}
//#endregion

//#region Example usage (won't actually run in tests)
(async () => {
  /** JSDoc with @tags
   *  @todo handle i18n
   *  @see https://example.com
   */
  const v1 = new Vector2(3, 4);
  const len = v1.length(); // 5

  const box = new Box(Vector2.ZERO).map((v) => v.add({ x: 1, y: 2 }));
  const ids = idGen();
  ids.next();
  ids.next();

  const file = path.join(process.cwd(), "README.md");
  const text: Maybe<string> = await readText(file).catch(() => null);

  // Label & continue are already exercised; also ternary & template:
  const status = text ? `ok:${text.length}` : "missing";

  console.log({ len, status, QUERY, proxyTag: proxy[sym] });
})().catch((err) => {
  // FIXME: refine error handling
  console.error("fatal:", err);
});
//#endregion

/* EOF */
