use utf8;

use Test::Base;
use Text::Md2Inao;

use Encode;

plan tests => 1 * blocks;

run_is in => 'expected';

sub md2inao {
    my $p = Text::Md2Inao->new({
        default_list           => 'disc',
        max_list_length        => 63,
        max_inline_list_length => 55,
    });
    $p->parse($_);
}

__END__
===
--- in md2inao
# 見出し1（大見出し、節）
--- expected
■見出し1（大見出し、節）

===
--- in md2inao
## 見出し2（中見出し、項）
--- expected
■■見出し2（中見出し、項）

===
--- in md2inao
### 見出し3（小見出し、目）
--- expected
■■■見出し3（小見出し、目）

===
--- in md2inao
改行は、（改行）
このように自動で取り除かれます。
--- expected
改行は、（改行）このように自動で取り除かれます。

===
--- in md2inao
通常の本文**強調（ボールド）**通常の本文
--- expected
通常の本文◆b/◆強調（ボールド）◆/b◆通常の本文

===
--- in md2inao
通常の本文_斜体（イタリック）_通常の本文
--- expected
通常の本文◆i/◆斜体（イタリック）◆/i◆通常の本文

===
--- in md2inao
通常の本文`インラインのコード`通常の本文
--- expected
通常の本文◆cmd/◆インラインのコード◆/cmd◆通常の本文

===
--- in md2inao
通常の本文(注:注釈ですよ。_イタリック_)通常の本文
--- expected
通常の本文◆注/◆注釈ですよ。◆i/◆イタリック◆/i◆◆/注◆通常の本文

===
--- in md2inao
通常の本文(注:注釈ですよ。)通常の本文
--- expected
通常の本文◆注/◆注釈ですよ。◆/注◆通常の本文

===
--- in md2inao
通常の本文<kbd>Enter</kbd>通常の本文
--- expected
通常の本文Enter▲通常の本文

===
--- in md2inao
通常の本文<span class='red'>赤文字</span>通常の本文
--- expected
通常の本文◆red/◆赤文字◆/red◆通常の本文

===
--- in md2inao
通常の本文<span class='ruby'>外村(ほかむら)</span>通常の本文
--- expected
通常の本文◆ルビ/◆外村◆ほかむら◆/ルビ◆通常の本文

===
--- in md2inao
> _引用_です**引用**です引用です引用です引用です引用です引用です引用です
> 引用です引用です引用です引用です引用です引用です引用です引用です
> 引用です引用です引用です引用です引用です引用です引用です引用です
> 引用です引用です引用です引用です引用です引用です引用です引用です
--- expected
◆quote/◆
◆i-j/◆引用◆/i-j◆です◆b/◆引用◆/b◆です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です引用です
◆/quote◆

===
--- in md2inao
<div class='column'>
#### コラム見出し

　**コラム**本文_コラム_本文コラム本文コラム本文コラム本文コラム本文コラム本文コラム本文コラム本文コラム本文コラム。

##### コラム小見出し

　コラム内でも**強調**などが使えます。
</div>
--- expected
◆column/◆
■■■■コラム見出し
　◆b/◆コラム◆/b◆本文◆i-j/◆コラム◆/i-j◆本文コラム本文コラム本文コラム本文コラム本文コラム本文コラム本文コラム本文コラム本文コラム。
■■■■■コラム小見出し
　コラム内でも◆b/◆強調◆/b◆などが使えます。
◆/column◆

===
--- in md2inao
* 通常の**箇条書き**
* 通常の_箇条書き_
* 通常の箇条書き
* 通常の箇条書き
* 通常の箇条書き
--- expected
・通常の◆b/◆箇条書き◆/b◆
・通常の◆i-j/◆箇条書き◆/i-j◆
・通常の箇条書き
・通常の箇条書き
・通常の箇条書き

===
--- in md2inao
1. 連番箇条書き（黒丸数字）
2. 連番箇条書き（黒丸数字）
3. 連番箇条書き（黒丸数字）
4. 連番箇条書き（黒丸数字）
5. 連番箇条書き（黒丸数字）
--- expected
（1）連番箇条書き（黒丸数字）
（2）連番箇条書き（黒丸数字）
（3）連番箇条書き（黒丸数字）
（4）連番箇条書き（黒丸数字）
（5）連番箇条書き（黒丸数字）

===
--- in md2inao
<ol class='circle'>
    <li>連番箇条書き（白丸数字）</li>
    <li>連番箇条書き（白丸数字）</li>
    <li>連番箇条書き（白丸数字）</li>
    <li>連番箇条書き（白丸数字）</li>
    <li>連番箇条書き（白丸数字）</li>
</ol>
--- expected
（○1）連番箇条書き（白丸数字）
（○2）連番箇条書き（白丸数字）
（○3）連番箇条書き（白丸数字）
（○4）連番箇条書き（白丸数字）
（○5）連番箇条書き（白丸数字）

===
--- in md2inao
<ol class='square'>
    <li>連番箇条書き（黒四角数字）</li>
    <li>連番箇条書き（黒四角数字）</li>
    <li>連番箇条書き（黒四角数字）</li>
    <li>連番箇条書き（黒四角数字）</li>
    <li>連番箇条書き（黒四角数字）</li>
</ol>
--- expected
［1］連番箇条書き（黒四角数字）
［2］連番箇条書き（黒四角数字）
［3］連番箇条書き（黒四角数字）
［4］連番箇条書き（黒四角数字）
［5］連番箇条書き（黒四角数字）

===
--- in md2inao
<ol class='alpha'>
    <li>連番箇条書き（アルファベット）</li>
    <li>連番箇条書き（アルファベット）</li>
    <li>連番箇条書き（アルファベット）</li>
    <li>連番箇条書き（アルファベット）</li>
    <li>連番箇条書き（アルファベット）</li>
</ol>
--- expected
（a）連番箇条書き（アルファベット）
（b）連番箇条書き（アルファベット）
（c）連番箇条書き（アルファベット）
（d）連番箇条書き（アルファベット）
（e）連番箇条書き（アルファベット）

===
--- in md2inao
　箇条書き以外の本文やリスト中で番号を書きたいときは、(d1)、(d2)、(c1)、(c2)、(s1)、(s2)、(a1)、(a2)のように書いてください。
--- expected
　箇条書き以外の本文やリスト中で番号を書きたいときは、（1）、（2）、（○1）、（○2）、［1］、［2］、（a）、（b）のように書いてください。

===
--- in md2inao
    ●リスト1.1::キャプション（コードのタイトル）
    function hoge() {
        alert(foo);　… (c1)
        alert(bar);　… (c2)
        alert(\c1); // \でエスケープできます
    }
--- expected
◆list/◆
●リスト1.1	キャプション（コードのタイトル）
function hoge() {
    alert(foo);　… （○1）
    alert(bar);　… （○2）
    alert(c1); // \でエスケープできます
}
◆/list◆

===
--- in md2inao
    function **foo**(a) { // コード内強調
        alert(a); (注:こんな風にコメントがつけられます)
    }

    (注:見出し的にも使えます)
    function bar(b) {
        alert(b);
    }
--- expected
◆list/◆
function ◆cmd-b/◆foo◆/cmd-b◆(a) { // コード内強調
    alert(a); ◆comment/◆こんな風にコメントがつけられます◆/comment◆
}

◆comment/◆見出し的にも使えます◆/comment◆
function bar(b) {
    alert(b);
}
◆/list◆

===
--- in md2inao
<table summary='表1.1::キャプション（表のタイトル）'>
    <tr>
        <th>表タイトル1</th>
        <th>表タイトル2</th>
    </tr>
    <tr>
        <td>内容1</td>
        <td>内容2</td>
    </tr>
    <tr>
        <td>内容1</td>
        <td>内容2</td>
    </tr>
</table>
--- expected
◆table/◆
●表1.1	キャプション（表のタイトル）
◆table-title◆表タイトル1	表タイトル2
内容1	内容2
内容1	内容2
◆/table◆

===
--- in md2inao
<span class='symbol'>→</span><span class='symbol'>←</span><span class='symbol'>↑</span><span class='symbol'>↓</span>
--- expected
◆→◆◆←◆◆↑◆◆↓◆

===
--- in md2inao
<span class='symbol'>←→</span>
--- expected
◆←→◆

=== hr
--- in md2inao
hogehoge

---

fugafuga
--- expected
hogehoge
=-=-=
fugafuga

