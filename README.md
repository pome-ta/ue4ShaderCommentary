# ue4ShaderCommentary


いつも、手元にUnreal Engine があるとは限らないので、テキストエディタで表現できる書き方を定義してみます 😇<br>
ノード(関数)と、ピン、ワイヤーを、文字で表現してみる試みちゃ☆

> 複雑なことを書かないと思うので、便宜的に(ワイちゃんオリジナル)



## 表記例

``` .hs
[<in: ピン> "ノード(関数)名" <out: ピン>]

```



### 具体例

``` .hs

[ "TexCoord" <(r, g)>] -> [<final_color: (r, g)> "最終出力"]
```

![画像例](https://docs.unrealengine.com/Images/RenderingAndGraphics/Materials/ExpressionReference/Coordinates/TextureCoordinateExample.jpg)

↑は、Texture を表示してるけど、UV だけで出せる([後述](#))

> [公式リファレンス(texturecoordinate)](https://docs.unrealengine.com/ja/RenderingAndGraphics/Materials/ExpressionReference/Coordinates/index.html#texturecoordinate)

マテリアルの設定で`UserInterface` にする。


ピンの`in` ,`out` の名前で繋ぐ的な、ワイヤーの表現をしてる

この場合だと、`TexCoord` の`out` にあるピンは、2つの値がある(`r = U` , `g = V` )

`最終出力` の`final_color` は、`R,G,B` 値を受け取れる。`r = R` ,`g = G` を`TexCoord` の数値から貰ってくる

> SyntaxHighlight 上、`in` `out` の名前で間にスペースがあるものは、`_` で繋いでる(スネークケース)









## 色を出力する


### 単色

[具体例](#具体例)のノードは、忘れるんだ😇 ただ、ノードの繋ぎ方をテキストで表現した説明なのだ😊


基礎の基礎から始める。まずは、単色の出力

`RGB` で色を表現できるので「赤、緑、青」は比較的扱いやすいので出力する。


#### 赤

``` .hs
[<R: 1.0, G: 0.0, B: 0.0> "Constant3Vector" <out: (R, G, B)>] -> [<final_color: (R, G, B)> "最終出力"]
```

> [公式リファレンス(Constant3Vector)](https://docs.unrealengine.com/ja/RenderingAndGraphics/Materials/ExpressionReference/Constant/index.html#constant3vector)


`TexCoord` 使うと思った？まだ、早いぞ 😇

なお、`Constant3Vector` のショートカットは、`3` 


赤色が出力されている(はず)だから、残りの2色も行ってみよー！(本機で挙動確認ができないのです。なので動かなかったスマン)


##### 他のアプローチ


リファレンス検索して見つからなくて、(私が)前に使ったはずの[`Make Vector`](https://docs.unrealengine.com/en-US/BlueprintAPI/Math/Vector/MakeVector/index.html) 的なやつのマテリアルエディタで使えるやつ？での実装もできる


やり方、考え方は同じで


``` .hs
[ "Constant" <R(とする): 1.0>] ->
[ "Constant" <G(とする): 0.0>] ->
[ "Constant" <B(とする): 0.0>] -> [<R, G, B> "make_vector(的なの)" <rgb: (R, G, B)>] -> [<final_color: (R, G, B)> "最終出力"]
```

このような感じで、単体ごとに色を指定し`make_vector(的なの)` で、出口を一つにする(「出口を一つ」は、[後述](#))



#### 原色以外の色

説明不要だと思うけど、`R`, `G`, `B` の数値を`0.0 ~ 1.0` 内で指定すれば表現できる

- `R: 1.0, G: 0.5, B: 0.0`
- `R: 0.0, G: 0.5, B: 0.0`
- `R: 1.0, G: 0.0, B: 1.0`
- `R: 0.5, G: 0.5, B: 1.0`

など、、、

あと以下もはずせない

- `R: 0.0, G: 0.0, B: 0.0`
- `R: 1.0, G: 1.0, B: 1.0`


え？`1.0` 以上だとどうなるか？だって？

うむ。君の手で実装し、君の目で結果を刮目せよ 😇

いい質問だ、精進するのだ


## 色が出力されるということ

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

### 単色赤の場合

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



### 仕組みとして

単色の場合、`Constant` で数値を指定した。指定した数値を変えたら全部の色が変わった

つまり、<b>座標</b>上の全てを指定した


先に結果から言うと

`TexCoord` は、座標の<b>一つ一つ</b>を指定できる仕組みなのだ 😊



## シェーダーというか、並列処理というか、GPU というか、3DCG というか


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





---

# メモ


ue の関数から探すのではなく、やりたいことをue の関数から探してる


[`TimeWithSpeedVariable`](https://docs.unrealengine.com/ja/RenderingAndGraphics/Materials/Functions/Reference/Misc/index.html#TimeWithSpeedVariable)

`time` に`Frac` なんていらなかったんや、、、

`SplitComponents`
