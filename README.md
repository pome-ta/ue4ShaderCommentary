# ue4ShaderCommentary


いつも、手元にUnreal Engine があるとは限らないので、テキストエディタで表現できる書き方を模索 😇<br>
ワイちゃんオリジナル


始まるよー 🤗



# 表記例

``` .hs
[<in: ピン> "ノード(関数)名" <out: ピン>]

```



## 具体例

``` .hs
[ "TexCoord" <out: (r, g)>] -> [<final_color: (r, g)> "最終出力"]
```

![画像例](https://docs.unrealengine.com/Images/RenderingAndGraphics/Materials/ExpressionReference/Coordinates/TextureCoordinateExample.jpg)
※ イメージ

> [公式リファレンス(texturecoordinate)](https://docs.unrealengine.com/ja/RenderingAndGraphics/Materials/ExpressionReference/Coordinates/index.html#texturecoordinate)


ピンの`in` ,`out` の名前で繋ぐ、ワイヤーの表現。

具体例だと、`TexCoord` の`out` にあるピンは、2つの値がある(`r = U` , `g = V` )。

`最終出力` の`final_color` は、`R,G,B` 値を受け取れる。`r = R` ,`g = G` を`TexCoord` の数値から貰ってくる。




# 色を出力する


## 単色

> [具体例](#具体例)のノードは、忘れるんだ😇 ただ、ノードの繋ぎ方をテキストで表現した説明なのだ😊


単色の出力。`RGB` で色を表現できるので「赤、緑、青」は簡単。


下のコードを見る前に作ってみよう！

### 赤

``` .hs
[<R: 1.0, G: 0.0, B: 0.0> "Constant3Vector" <out: (R, G, B)>] -> [<final_color: (R, G, B)> "最終出力"]
```

> [公式リファレンス(Constant3Vector)](https://docs.unrealengine.com/ja/RenderingAndGraphics/Materials/ExpressionReference/Constant/index.html#constant3vector)


`TexCoord` 使うと思った？まだ、早いぞ 😇

なお、`Constant3Vector` のショートカットは、`3` 。


赤色が出力されている(はず)だから、残りの2色も行ってみよー！(本機で挙動確認ができないのです。なので動かなかったスマン)。


#### 他のアプローチ


リファレンス検索して見つからなくて、(私が)前に使ったはずの[`Make Vector`](https://docs.unrealengine.com/en-US/BlueprintAPI/Math/Vector/MakeVector/index.html) 的なやつのマテリアルエディタで使えるやつ？での実装もできる。


`make float3` とかだったか？(なんせ、全然リファレンスが上手に探せない。。。)


やり方、考え方は同じ。


``` .hs
[ "Constant" <R(とする): 1.0>] ->
[ "Constant" <G(とする): 0.0>] ->
[ "Constant" <B(とする): 0.0>] -> [<R, G, B> "make_float3(的なの)" <rgb: (R, G, B)>] -> [<final_color: (R, G, B)> "最終出力"]
```

このような感じで、単体ごとに色を指定し`make_vector(的なの)` で、出口を一つにする。



### 原色以外の色

`R`, `G`, `B` の数値を`0.0 ~ 1.0` 内で指定すれば表現できる。

- `R: 1.0, G: 0.5, B: 0.0`
- `R: 0.0, G: 0.5, B: 0.0`
- `R: 1.0, G: 0.0, B: 1.0`
- `R: 0.5, G: 0.5, B: 1.0`

など、、、

あと以下もはずせない。

- `R: 0.0, G: 0.0, B: 0.0`
- `R: 1.0, G: 1.0, B: 1.0`


え？`1.0` 以上だとどうなるか？だって？

いい質問だ

うむ。君の手で実装し、君の目で結果を刮目せよ 😇

精進するのだ。




## 色を動かす


単色が出せたので、つぎは変化をつける。

まだまだ、`TexCoord` は使わせないぞー 😊



``` .hs
[ "Time" <out: time>] -> [<final_color: time> "最終出力"]
```

なんか、出ると思ったでしょ？

残念でしたー！真っ白(の、はず)でーす 😩



``` .hs
[ "Time" <out: time>] -> [<in: time > "sine" <out: sine>] -> [<in: sine> "Abs" <out: abs>] -> [<final_color: abs> "最終出力"]
```

白黒で、チカチカと点滅する(してくれないと困る)する。


### `time` と`sine` と `abs`

コードを見ていく。

``` .hs
{- 見辛いから、改行しているけど、上と同じ -}
[ "Time" <out: time>]
-> [<in: time > "sine" <out: sine>] -> [<in: sine> "Abs" <out: abs>]
-> [<final_color: abs> "最終出力"]
```



1. `Time` は常に数値を出している(増えていく)
1. `Sine` 関数は、`-1.0 ~ 1.0` 内の数値を出す
1. `-1.0 ~ 1.0` が`Abs` に入ると、`-` 値だったものが`+` になる


- `Time` と`Sine` で、きれいに波打つと考えればいい(今は)
- `Abs` が入ると、マイナスにいかない(`0.0 ~ 1.0` ~ `1.0 ~ 0.0`)


以下公式リファレンス祭り、書かれ方やクセなど体に馴染ませておくこと(接続重いのよね)


#### [`Time`](https://docs.unrealengine.com/ja/RenderingAndGraphics/Materials/ExpressionReference/Constant/index.html#time)

説明せんでも、わかるやろ？ 😇


#### [`Sine`](https://docs.unrealengine.com/ja/RenderingAndGraphics/Materials/ExpressionReference/Math/index.html#Sine)

リファレンスの本文で、読み解くところは
> Sine 式は、[0、1] の入力範囲と [-1、1] の出力範囲にサイン波の値繰り返し出力します。

ここと、
> 出力範囲は [0、1] に調整しています。

あと、画像を見ておけばいい。


![画像](https://docs.unrealengine.com/Images/RenderingAndGraphics/Materials/ExpressionReference/Math/SineWave.webp)

`Cosine` 実行してみてもいいけど、今回のノードの組み合わせだと変化を感じないと思うで


#### [`Abs`](https://docs.unrealengine.com/ja/RenderingAndGraphics/Materials/ExpressionReference/Math/index.html#abs)

読み解くところは

> 基本的にマイナス符号を取り除くことで負の数を正の数に変えます。正の数と 0 の場合は変化しません。

> 例： -0.7 の Abs は 0.7 、-1.0 の Abs は 1.0、1.0 の Abs は 1.0 です。




次に、2つの派生系を考えていきたい。


- チカチカする速さを変える
- 他の色でチカチカさせたい

関数のノードも使い始めたので、速度を変えることから




### 点滅の速さを変える


なにかの数値を変化させれば、なにかが変わる。

では、何を変えるのか？


#### 検討材料

`[関数] -> [関数]` の間`->` に何かこねくり回して数値を変えればいい。

- `Abs`
  - マイナス値をプラスに変化させる
  - 現状`Abs` が吐き出しているのは`0.0 ~ 1.0` の間の数値
  - ここで、2で割ったら数値としては小さくなる！
    - 最終到達の数値(Max の値)が、`0.5` になってしまう
  - 足したり、引いたり、割ったりするのも同様

- `Sine`
  - 脳を殺して`-1.0 ~ 1.0` の数値を丁寧に渡している
  - 最終結果のMax値が、`1.0` 以上とかになると、`Abs` に渡す前の演算だと、ピッタリ行かない気がする。。。`-1.0 ~ 1.0` で渡したいため

- `Time`
  - 刻一刻と数値が増えていっている
  - 時間は、ゲーム全体で共有してるので、直接魔改造すると、みんな死ぬ 😇
  - 「時間」から、出でくる数値の操作
    - つまりここ


``` .hs
[ "Time" <out: time>]
{- ここにノードを追加 -}
-> [<A: time, B: 0.1> "Multiply" <out: mul>]
-> [<in: mul> "sine" <out: sine>] -> [<in: sine> "Abs" <out: abs>]
-> [<final_color: abs> "最終出力"]
```

[`Multiply`](https://docs.unrealengine.com/ja/RenderingAndGraphics/Materials/ExpressionReference/Math/index.html#multiply)



`Time` から、増えてくる数値を掛け算(今回の例だと`0.1`)

これで、カウントアップされる数値が1/10 遅くなる。

なぜ、割り算(`Divide`) ではなく掛け算(`Multiply`) なのか？

`0` を割ろうとすると、エラーになったりして面倒かなぁと思って！(なので、最適解は任せる)

速度を上げたい場合には、1以上の数値を掛けてあげればいい。



## 発色する色を変える

なぜ`黒 -> 白 -> 黒 -> 白` の繰り返しなのか？


この理由がわかると、`Debug` 系のノードを使えるようになる。検証も、実験も、失敗している理由もわかりやすくなる。


### 白だった理由

`final_color` に、`(0.0, 0.0, 0.0) ~ (1.0, 1.0, 1.0)` の数値をいれているから。


一つのピンで挿入しているのに、`RGB` の3つの値が入るのは、何故なのか？

`Constant3Vector` の仕組みがわかると理解できる。

`Constant3Vector` は、`RGB` の値を事前に指定。

この値を `vec3` と言う。`vec3` として、3つの数値の情報をもった塊を一つの値とする。


ちなみに、一つの値の場合は、`Scalar` とか`float` とか`Constant` 呼ばれる。


``` .hs
{- 一つの値を3つ作ってる -}
[ "Constant" <R(とする): 1.0>] ->
[ "Constant" <G(とする): 0.0>] ->  {- 3つの値を、合わせて vec3 へ -}
[ "Constant" <B(とする): 0.0>] -> [<R, G, B> "make_float3(的なの)" <rgb: (R, G, B)>] -> [<final_color: (R, G, B)> "最終出力"]
```






`out` が`float` の生身の1つの値で、`in` が`vec3` で、1つのピンだとしても実行はできます。1つの値を、`vec3` のひとつひとつに、ぶち込む。


``` .hs
[ "Time" <out: time>] -> [<in: time > "sine" <out: sine>] -> [<in: sine> "Abs" <out: abs>]
   {- 一つの値をvec3 3つにブチ込み -}
-> [<final_color: abs> "最終出力"]
```


つまり、今回の点滅であれば`final_color` へ、`R`, `G`, `B` の`vec3` 情報を送りつければ色が変更できる。



`make_float3` 的なものを使って、3つの数値をひとまとめにして、`final_color` へ送りつけてあげましょう！


(値 a.k.a. `型` については、まだ色々と説明が必要なのですが、まずまず力技でなんとかできると思います、もしエラーがでても、エラー表記から、何かが足りない or 違う というのが気がつけるようになると思います)


ちなみに、`final_color` は`vec3` を受けることができ、`vec4`(色でいうとアルファ値) で来た場合は、エラーも吐かずに、しれっと4つ目の値を捨てます。

変化しない場合などは、そうやって、不要な数値を入れていて隠蔽されている可能性あり 🤔



アルファ値でいうと、`Transparency` か`Opacity` とかのピンがあったはず


また、`vec2` から`vec3` に送ると、エラーになる(基本的には、そのままするっと通すのもあるので注意)


### 派生系を作ろう

`RGB` それぞれ(`vec3`) の数値を自由にいじり、合体させて`final_color` に送ることができる説明をした。

つまり、点滅する3種それぞれに、違う関数を入れると変化を楽しめる。



`R` には`Sine` を、`G` には`Cosine` を、`B` には`Tangent`

それぞれ、`abs` でマイナスに行かないように調整をしてあげたり


掛け算の数値をそれぞれバラバラにしてあげると、色々な変化が見られる(もちろん`abs` を外してもいい)。



これが、なぜ`Texture` の描画になるの？というのはまた次回




# 色が出力されるということ

`TexCoord` だと、グラデーションで出力されるのに、今回は全面単色。何故なのか？

ここでやっと(フラグメント(ピクセル))シェーダーの考え方が必要になってくる



3 x 3 のマス目があるとする(`.0` は、`0.0`。`.5` は、`0.5`)

```
(x: よこ, y: たて) = 座標

             |              |
(  .0, .0  ) | (  .5, .0  ) | (  1., .0  )
             |              |
-------------|--------------|-------------
             |              |
(  .0, .5  ) | (  .5, .5  ) | (  1., .5  )
             |              |
-------------|--------------|-------------
             |              |
(  .0, 1.  ) | (  .5, 1.  ) | (  1., 1.  )
             |              |
             |              |

```

## 単色赤の場合

<b>座標</b>上、全部を「赤」にすればいいので

```
(r, g, b) = RGBカラー

             |              |
(1., .0, .0) | (1., .0, .0) | (1., .0, .0)
             |              |
-------------|--------------|-------------
             |              |
(1., .0, .0) | (1., .0, .0) | (1., .0, .0)
             |              |
-------------|--------------|-------------
             |              |
(1., .0, .0) | (1., .0, .0) | (1., .0, .0)
             |              |
             |              |
```

これで、済む



## 仕組みとして

単色の場合、`Constant` で数値を指定した。指定した数値を変えたら全部の色が変わった

つまり、<b>座標</b>上の全てを指定した


先に結果から言うと

`TexCoord` は、座標の<b>一つ一つ</b>を指定できる仕組みなのだ 😊


## 時間の考え方

上記は、一枚絵の変化しない描画について。

`Time` 関数などを使って、時間の軸を追加すると、フレーム毎(？)に、描画されパラパラ漫画のようになる仕組み。



# シェーダーというか、並列処理というか、GPU というか、3DCG というか


人間の頭は、(多分)シングルタスクなので、順を追って説明をすると、、、



3 x 3 の場合

1. 「描画しますよー 🤗」と、指示が来る
1. 最初の`(0.0, 0.0)` に塗るための色の指示を探す
1. `RGB`値 の指示を受け取り`(0.0, 0.0)` に着色
1. 次の`(0.5, 0.0)` に塗るための色の指示を探す
1. `RGB`値 の指示を受け取り`(0.5, 0.0)` に着色
1. (中略)
1. 最後の`(1.0, 1.0)` に塗るための色の指示を探す
1. `RGB`値 の指示を受け取り`(1.0, 1.0)` に着色
1. 全マス「着色できますた 😭」と報告あり
1. 描画される


シェーダー処理は、「指示」と「報告」の間の手順を一括で処理をする


考え方的に難しいのが、この「一括処理」の部分だと(ワイ)は考えている


`Constant` の`1.0` は、「`1.0`」という<b>ひとつ</b>の数値ではなく、「`1.0`, `1.0`, `1.0`」という数値なのですす(3 x 3の場合)


`TexCoord` の数値は、`U` が「`0.0`, `0.5`, `1.0`」`V` が「`0.0`, `0.5`, `1.0`」を持っており

それぞれの組み合わせ(座標の(x, y)) に振られていくのです


これ(再掲)

```
(x: よこ, y: たて) = 座標

             |              |
(  .0, .0  ) | (  .5, .0  ) | (  1., .0  )
             |              |
-------------|--------------|-------------
             |              |
(  .0, .5  ) | (  .5, .5  ) | (  1., .5  )
             |              |
-------------|--------------|-------------
             |              |
(  .0, 1.  ) | (  .5, 1.  ) | (  1., 1.  )
             |              |
             |              |

```


## つらい、、つらい、、

つらい。なんでつらいのか？


それは「気がついたら、<b>数値</b>が他の意味の数値に変わってる」から(ん？ちょっと違うかもスマン)



「`x` 軸のことを考えていたら、色指定のことを忘れていた or 考える必要があった」

「色が変わるということは、座標的にどうなるのだ？」

「`time` で取得した数値は、色？位置？」

「なんか、できた」


あるあるである。


### 脱線(愚痴)

そもそものところ、シェーダープログラミング(ノードであっても)は、ほかのプログラミングよりも難しい(言い切ってしまうと`C++` よりも)


一般的なプログラミングは、シェーダーが描画される手順をひとつひとつ行う。シェーダープログラムは、一気にやる<b>狂ってる</b>。


しかも、3DCG プログラムは`RGB` の数値(色)を`XYZ` の空間座標に置き換える。とかを普通？常識よ？のような顔でやる<b>狂気の沙汰</b>である。


我々凡人は、そのアーキテクチャを考えた狂人の肩を借りているのだから<b>使いこなせる訳がない</b>



描画の仕組みを理解した上で、トライアンドエラーを繰り返して、脳筋を鍛えるしかない





# Texture と触れ合う

> 私の理解用になる項目かも


## UV Checker

当分テクスチャには、`TextureParameter2D` で呼び出せるテンプレのueロゴを使って行く予定。


必要に応じ(私が、アセット配布理解した頃に)


![UVCheckerMap01-512.png](https://github.com/Arahnoid/UVChecker-map/blob/master/UVCheckerMaps/UVCheckerMap01-512.png)

[Arahnoid/UVChecker-map](https://github.com/Arahnoid/UVChecker-map) をお借りする(予定)、GitHub にリポジトリとしてあり、

> This work (UVChecker-map, by Igor Grinchesku) is free of known copyright restrictions.

と、ライセンスも明記されてるので。



UV 座標の目視確認的に、


![UV_Grid_Sm.jpg](http://www.pixelsham.com/wp-content/uploads/2016/07/UV_Grid_Sm.jpg)

の、方が良さげなのだが、[配布先](http://www.pixelsham.com/2018/09/29/uv-maps/) を見る限り、明確なライセンスがないため却下。


> 暇が度を越えたら作ろうと思う(多分作らない)



## メモ

### リファレンス

- [マテリアル式のリファレンス](https://docs.unrealengine.com/ja/RenderingAndGraphics/Materials/ExpressionReference/index.html)
  - ここで`[ctrl + f]` が正義かも🦸‍♂️

- [Texture の表現式](https://docs.unrealengine.com/ja/RenderingAndGraphics/Materials/ExpressionReference/Textures/index.html)

- [マップ チェック エラー](https://docs.unrealengine.com/ja/BuildingWorlds/LevelEditor/MapErrors/index.html)

### 読み物

- [[UE4] マテリアルノードの解説 その1 | もんしょの巣穴blog](http://monsho.blog63.fc2.com/blog-entry-133.html)
	- Mathカテゴリの解説
		- 四則演算と剰余算
  		- `Add`
	  		- `+`
  		- `Subtract`
	  		- `-`
  		- `Multiply`
	  		- `*`
  		- `Divide`
	  		- `/`
  		- `Fmod`
	  		- `%`
		- `LinearInterpolate`
			- `Lerp`
			- 線形補間
		- `OneMinus`
			- `1 - x`
		- `Floor`
		- `Frac`
		- `Clamp`
		- `Max`
		- `Min`
		- `Abs`
		- `Power`
		- `SquareRoot`
			- `Sqrt`
		- `DotProduct`
			- `Dot`
			- 内積
		- `CrossProduct`
			- `Cross`
			- 外積
		- `Normalize`
		- `SafeNormalize`
		- `AppendVector`
		- `If`
	- > マテリアルによって生成されるシェーダは、この辺の処理が明確な場合はコンパイラが勝手にそれっぽい計算をしてしまいます。例えば、`float4` の`vectorValue` と`float` の`floatValue` があったと仮定し、これを加算した場合、結果は以下のようになります。
	- > `resultValue = {vectorValue.x + floatValue, vectorValue.y + floatValue, vectorValue.z + floatValue, vectorValue.w + floatValue}; `
		- `vec4`(`vectorValue`) を`x`, `y`, `z`, `w` と分割し、それぞれに`floatValue` を加算している。
	- > ちなみに、明確でない場合はコンパイラがエラーを返します。
	- > これを機にシェーダコードを書いてみる、ってのもありかとは思いますが。
		- > これを機にシェーダコードを書いてみる、ってのもありかとは思いますが。
			- > これを機にシェーダコードを書いてみる、ってのもありかとは思いますが。

- [[UE4] マテリアルノードの解説 その2 | もんしょの巣穴blog](http://monsho.blog63.fc2.com/blog-entry-134.html)
	- `TextureSample`
		- > 設定されたテクスチャはマテリアルで固定されるため、外部から変更することはできなくなります。
	- `TextureSampleParameter`
		- > TextureSampleとは違って外部から変更することが可能ですが、使用するテクスチャの種類についてだけは固定化されています。
	- `TextureCoordinate`
		- `TexCoord`
		- > UVを時間経過に合わせて移動したり歪ませたりするには、このノードの出力を加工してテクスチャサンプルを行ってください。
- [[UE4] マテリアルノードの解説 補足の1 | もんしょの巣穴blog](http://monsho.blog63.fc2.com/blog-entry-135.html?sp)
- [[UE4] マテリアルノードの解説 その3 | もんしょの巣穴blog](http://monsho.blog63.fc2.com/blog-entry-136.html?sp)


---

# メモ


ue の関数から探すのではなく、やりたいことをue の関数から探してる


[`TimeWithSpeedVariable`](https://docs.unrealengine.com/ja/RenderingAndGraphics/Materials/Functions/Reference/Misc/index.html#TimeWithSpeedVariable)

`time` に`Frac` なんていらなかったんや、、、

`SplitComponents`
