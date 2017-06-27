# Source adapted from https://github.com/reima/diff_match_patch-ruby
require 'spec_helper'
require 'sboot/diff_patch_match'

describe DiffPatchMatch do
    subject(:dmp){ DiffPatchMatch.new }
    
    describe 'Detect any common prefix' do
        it 'Null case' do
            expect(dmp.diff_commonPrefix('abc', 'xyz')).to be(0)
        end
        
        it 'Non-null case' do
            expect(dmp.diff_commonPrefix('1234abcdef', '1234xyz')).to be(4)
        end
        
        it 'Whole case' do
            expect(dmp.diff_commonPrefix('1234', '1234xyz')).to be(4)
        end
    end
    
    describe 'Detect any common suffix' do
        it 'Null case' do
            expect(dmp.diff_commonSuffix('abc', 'xyz')).to be(0)
        end
        
        it 'Non-null case' do
            expect(dmp.diff_commonSuffix('abcdef1234', 'xyz1234')).to be(4)
        end
        
        it 'Whole case' do
            expect(dmp.diff_commonSuffix('1234', 'xyz1234')).to be(4)
        end
    end
    
    describe 'Detect any suffix/prefix overlap' do
        it 'Null case' do
            expect(dmp.diff_commonOverlap('', 'abcd')).to be(0)
        end
        
        it 'Whole case' do
            expect(dmp.diff_commonOverlap('abc', 'abcd')).to be(3)
        end
        
        it 'No overlap' do
            expect(dmp.diff_commonOverlap('123456', 'abcd')).to be(0)
        end
        
        it 'Overlap' do
            expect(dmp.diff_commonOverlap('123456xxx', 'xxxabcd')).to be(3)
        end
    end
    
    describe 'Detect a halfmatch' do
        before(:each) { dmp.diff_timeout = 1 }
        
        it 'No match' do
            expect(dmp.diff_halfMatch('1234567890', 'abcdef')).to be(nil)
            expect(dmp.diff_halfMatch('12345', '23')).to be(nil)
        end
        
        it 'Single Match' do
            expect(dmp.diff_halfMatch('1234567890', 'a345678z')).to eq(['12', '90', 'a', 'z', '345678'])
            expect(dmp.diff_halfMatch('a345678z', '1234567890')).to eq(['a', 'z', '12', '90', '345678'])
            expect(dmp.diff_halfMatch('abc56789z', '1234567890')).to eq(['abc', 'z', '1234', '0', '56789'])
            expect(dmp.diff_halfMatch('a23456xyz', '1234567890')).to eq(['a', 'xyz', '1', '7890', '23456'])
            expect(dmp.diff_halfMatch('121231234123451234123121', 'a1234123451234z')).to eq(['12123', '123121', 'a', 'z', '1234123451234'])
            expect(dmp.diff_halfMatch('x-=-=-=-=-=-=-=-=-=-=-=-=', 'xx-=-=-=-=-=-=-=')).to eq(['', '-=-=-=-=-=', 'x', '', 'x-=-=-=-=-=-=-='])
            expect(dmp.diff_halfMatch('-=-=-=-=-=-=-=-=-=-=-=-=y', '-=-=-=-=-=-=-=yy')).to eq(['-=-=-=-=-=', '', '', 'y', '-=-=-=-=-=-=-=y'])
        end
        
        it 'Non-optimal halfmatch' do
            # Optimal diff would be -q+x=H-i+e=lloHe+Hu=llo-Hew+y not -qHillo+x=HelloHe-w+Hulloy
            expect(dmp.diff_halfMatch('qHilloHelloHew', 'xHelloHeHulloy')).to eq(['qHillo', 'w', 'x', 'Hulloy', 'HelloHe'])
        end
        
        it 'Optimal no halfmatch' do
            dmp.diff_timeout = 0
            expect(dmp.diff_halfMatch('qHilloHelloHew', 'xHelloHeHulloy')).to eq(nil)
        end
    end
    
    describe 'Convert lines down to characters' do
        it 'Simple' do
            expect(dmp.diff_linesToChars("alpha\nbeta\nalpha\n", "beta\nalpha\nbeta\n")).to eq(["\x01\x02\x01", "\x02\x01\x02", ['', "alpha\n", "beta\n"]])
            expect(dmp.diff_linesToChars('', "alpha\r\nbeta\r\n\r\n\r\n")).to eq(['', "\x01\x02\x03\x03", ['', "alpha\r\n", "beta\r\n", "\r\n"]])
            expect(dmp.diff_linesToChars('a', 'b')).to eq(["\x01", "\x02", ['', 'a', 'b']])
        end
        
        it 'More than 256 to reveal any 8-bit limitations' do
            n = 300
            line_list = (1..n).map {|x| x.to_s + "\n" }
            char_list = (1..n).map {|x| x.chr(Encoding::UTF_8) }
            expect(line_list.length).to eq(n)
            lines = line_list.join
            chars = char_list.join
            expect(chars.length).to eq(n)
            line_list.unshift('')
            expect(dmp.diff_linesToChars(lines, '')).to eq([chars, '', line_list])
        end
    end
    
    describe 'Convert chars up to lines' do
        it 'Simple' do
            diffs = [Diff.new(:equal, "\x01\x02\x01"), Diff.new(:insert, "\x02\x01\x02")]
            dmp.diff_charsToLines(diffs, ['', "alpha\n", "beta\n"])
            expect(diffs).to eq([Diff.new(:equal, "alpha\nbeta\nalpha\n"), Diff.new(:insert, "beta\nalpha\nbeta\n")])
        end
        
        it 'More than 256 to reveal any 8-bit limitations' do
            n = 300
            line_list = (1..n).map {|x| x.to_s + "\n" }
            char_list = (1..n).map {|x| x.chr(Encoding::UTF_8) }
            expect(line_list.length).to eq(n)
            lines = line_list.join
            chars = char_list.join
            expect(chars.length).to eq(n)
            line_list.unshift('')
            
            diffs = [Diff.new(:delete, chars)]
            dmp.diff_charsToLines(diffs, line_list)
            expect(diffs).to eq([Diff.new(:delete, lines)])
        end
    end
    
    describe 'Cleanup a messy diff' do
        it 'Null case' do
            diffs = []
            dmp.diff_cleanupMerge(diffs)
            expect(diffs).to eq([])
        end
        
        it 'No change case' do
            diffs = [Diff.new(:equal, 'a'), Diff.new(:delete, 'b'), Diff.new(:insert, 'c')]
            dmp.diff_cleanupMerge(diffs)
            expect(diffs).to eq([Diff.new(:equal, 'a'), Diff.new(:delete, 'b'), Diff.new(:insert, 'c')])
        end
        
        it 'Merge equalities' do
            diffs = [Diff.new(:equal, 'a'), Diff.new(:equal, 'b'), Diff.new(:equal, 'c')]
            dmp.diff_cleanupMerge(diffs)
            expect(diffs).to eq([Diff.new(:equal, 'abc')])
        end
        
        it 'Merge deletions' do
            diffs = [Diff.new(:delete, 'a'), Diff.new(:delete, 'b'), Diff.new(:delete, 'c')]
            dmp.diff_cleanupMerge(diffs)
            expect(diffs).to eq([Diff.new(:delete, 'abc')])
        end
        
        it 'Merge insertions' do
            diffs = [Diff.new(:insert, 'a'), Diff.new(:insert, 'b'), Diff.new(:insert, 'c')]
            dmp.diff_cleanupMerge(diffs)
            expect(diffs).to eq([Diff.new(:insert, 'abc')])
        end
        
        it 'Merge interweave' do
            diffs = [
                Diff.new(:delete, 'a'), Diff.new(:insert, 'b'), Diff.new(:delete, 'c'),
                Diff.new(:insert, 'd'), Diff.new(:equal, 'e'), Diff.new(:equal, 'f')
            ]
            dmp.diff_cleanupMerge(diffs)
            expect(diffs).to eq([Diff.new(:delete, 'ac'), Diff.new(:insert, 'bd'), Diff.new(:equal, 'ef')])
        end
        
        it 'Prefix and suffix detection' do
            diffs = [Diff.new(:delete, 'a'), Diff.new(:insert, 'abc'), Diff.new(:delete, 'dc')]
            dmp.diff_cleanupMerge(diffs)
            expect(diffs).to eq([Diff.new(:equal, 'a'), Diff.new(:delete, 'd'), Diff.new(:insert, 'b'), Diff.new(:equal, 'c')])
        end
        
        it 'Prefix and suffix detection with equalities' do
            diffs = [
                Diff.new(:equal, 'x'), Diff.new(:delete, 'a'), Diff.new(:insert, 'abc'),
                Diff.new(:delete, 'dc'), Diff.new(:equal, 'y')
            ]
            dmp.diff_cleanupMerge(diffs)
            expect(diffs).to eq([Diff.new(:equal, 'xa'), Diff.new(:delete, 'd'), Diff.new(:insert, 'b'),Diff.new(:equal, 'cy')])
        end
        
        it 'Slide edit left' do
            diffs = [Diff.new(:equal, 'a'), Diff.new(:insert, 'ba'), Diff.new(:equal, 'c')]
            dmp.diff_cleanupMerge(diffs)
            expect(diffs).to eq([Diff.new(:insert, 'ab'), Diff.new(:equal, 'ac')])
        end
        
        it 'Slide edit right' do
            diffs = [Diff.new(:equal, 'c'), Diff.new(:insert, 'ab'), Diff.new(:equal, 'a')]
            dmp.diff_cleanupMerge(diffs)
            expect(diffs).to eq([Diff.new(:equal, 'ca'), Diff.new(:insert, 'ba')])
        end
        
        it 'Slide edit left recursive' do
            diffs = [
                Diff.new(:equal, 'a'), Diff.new(:delete, 'b'), Diff.new(:equal, 'c'),
                Diff.new(:delete, 'ac'), Diff.new(:equal, 'x')
            ]
            dmp.diff_cleanupMerge(diffs)
            expect(diffs).to eq([Diff.new(:delete, 'abc'), Diff.new(:equal, 'acx')])
        end
        
        it 'Slide edit right recursive' do
            diffs = [
                Diff.new(:equal, 'x'), Diff.new(:delete, 'ca'), Diff.new(:equal, 'c'),
                Diff.new(:delete, 'b'), Diff.new(:equal, 'a')
            ]
            dmp.diff_cleanupMerge(diffs)
            expect(diffs).to eq([Diff.new(:equal, 'xca'), Diff.new(:delete, 'cba')])
        end
    end
    
    describe 'Slide diffs to match logical boundaries' do
        it 'Null case' do
            diffs = []
            dmp.diff_cleanupSemanticLossless(diffs)
            expect(diffs).to eq([])
        end
        
        it 'Blank lines' do
            diffs = [
                Diff.new(:equal, "AAA\r\n\r\nBBB"), Diff.new(:insert, "\r\nDDD\r\n\r\nBBB"),
                Diff.new(:equal, "\r\nEEE")
            ]
            dmp.diff_cleanupSemanticLossless(diffs)
            expect(diffs).to eq([Diff.new(:equal, "AAA\r\n\r\n"), Diff.new(:insert, "BBB\r\nDDD\r\n\r\n"),Diff.new(:equal, "BBB\r\nEEE")])
        end
        
        it 'Line boundaries' do
            diffs = [
                Diff.new(:equal, "AAA\r\nBBB"), Diff.new(:insert, " DDD\r\nBBB"),
                Diff.new(:equal, " EEE")
            ]
            dmp.diff_cleanupSemanticLossless(diffs)
            expect(diffs).to eq([Diff.new(:equal, "AAA\r\n"), Diff.new(:insert, "BBB DDD\r\n"),Diff.new(:equal, "BBB EEE")])
        end
        
        it 'Word boundaries' do
            diffs = [
                Diff.new(:equal, 'The c'), Diff.new(:insert, 'ow and the c'),
                Diff.new(:equal, 'at.')
            ]
            dmp.diff_cleanupSemanticLossless(diffs)
            expect(diffs).to eq([Diff.new(:equal, 'The '), Diff.new(:insert, 'cow and the '),Diff.new(:equal, 'cat.')])
        end
        
        it 'Alphanumeric boundaries' do
            diffs = [
                Diff.new(:equal, 'The-c'), Diff.new(:insert, 'ow-and-the-c'),
                Diff.new(:equal, 'at.')
            ]
            dmp.diff_cleanupSemanticLossless(diffs)
            expect(diffs).to eq([Diff.new(:equal, 'The-'), Diff.new(:insert, 'cow-and-the-'),Diff.new(:equal, 'cat.')])
        end
        
        it 'Hitting the start' do
            diffs = [Diff.new(:equal, 'a'), Diff.new(:delete, 'a'), Diff.new(:equal, 'ax')]
            dmp.diff_cleanupSemanticLossless(diffs)
            expect(diffs).to eq([Diff.new(:delete, 'a'), Diff.new(:equal, 'aax')])
        end
        
        it 'Hitting the end' do
            diffs = [Diff.new(:equal, 'xa'), Diff.new(:delete, 'a'), Diff.new(:equal, 'a')]
            dmp.diff_cleanupSemanticLossless(diffs)
            expect(diffs).to eq([Diff.new(:equal, 'xaa'), Diff.new(:delete, 'a')])
        end
    end
    
    describe 'Cleanup semantically trivial equalities' do
        it 'Null case' do
            diffs = []
            dmp.diff_cleanupSemantic(diffs)
            expect(diffs).to eq([])
        end
        
        it 'No elimination #1' do
            diffs = [
                Diff.new(:delete, 'ab'), Diff.new(:insert, 'cd'), Diff.new(:equal, '12'),
                Diff.new(:delete, 'e')
            ]
            dmp.diff_cleanupSemantic(diffs)
            expect(diffs).to eq([Diff.new(:delete, 'ab'), Diff.new(:insert, 'cd'), Diff.new(:equal, '12'),Diff.new(:delete, 'e')])
        end
        
        it 'No elimination #2' do
            diffs = [
                Diff.new(:delete, 'abc'), Diff.new(:insert, 'ABC'), Diff.new(:equal, '1234'),
                Diff.new(:delete, 'wxyz')
            ]
            dmp.diff_cleanupSemantic(diffs)
            expect(diffs).to eq([Diff.new(:delete, 'abc'), Diff.new(:insert, 'ABC'), Diff.new(:equal, '1234'),Diff.new(:delete, 'wxyz')])
        end
        
        it 'Simple elimination' do
            diffs = [Diff.new(:delete, 'a'), Diff.new(:equal, 'b'), Diff.new(:delete, 'c')]
            dmp.diff_cleanupSemantic(diffs)
            expect(diffs).to eq([Diff.new(:delete, 'abc'), Diff.new(:insert, 'b')])
        end
        
        it 'Backpass elimination' do
            diffs = [
                Diff.new(:delete, 'ab'), Diff.new(:equal, 'cd'), Diff.new(:delete, 'e'),
                Diff.new(:equal, 'f'), Diff.new(:insert, 'g')
            ]
            dmp.diff_cleanupSemantic(diffs)
            expect(diffs).to eq([Diff.new(:delete, 'abcdef'), Diff.new(:insert, 'cdfg')])
        end
        
        it 'Multiple eliminations' do
            diffs = [
                Diff.new(:insert, '1'), Diff.new(:equal, 'A'), Diff.new(:delete, 'B'),
                Diff.new(:insert, '2'), Diff.new(:equal, '_'), Diff.new(:insert, '1'),
                Diff.new(:equal, 'A'), Diff.new(:delete, 'B'), Diff.new(:insert, '2')
            ]
            dmp.diff_cleanupSemantic(diffs)
            expect(diffs).to eq([Diff.new(:delete, 'AB_AB'), Diff.new(:insert, '1A2_1A2')])
        end
        
        it 'Word boundaries' do
            diffs = [
                Diff.new(:equal, 'The c'), Diff.new(:delete, 'ow and the c'),
                Diff.new(:equal, 'at.')
            ]
            dmp.diff_cleanupSemantic(diffs)
            expect(diffs).to eq([Diff.new(:equal, 'The '), Diff.new(:delete, 'cow and the '),Diff.new(:equal, 'cat.')])
        end
        
        it 'Overlap elimination' do
            diffs = [Diff.new(:delete, 'abcxxx'), Diff.new(:insert, 'xxxdef')]
            dmp.diff_cleanupSemantic(diffs)
            expect(diffs).to eq([Diff.new(:delete, 'abc'), Diff.new(:equal, 'xxx'), Diff.new(:insert, 'def')])
        end
        
        it 'Two overlap eliminations' do
            diffs = [
                Diff.new(:delete, 'abcd1212'), Diff.new(:insert, '1212efghi'),
                Diff.new(:equal, '----'), Diff.new(:delete, 'A3'), Diff.new(:insert, '3BC')
            ]
            dmp.diff_cleanupSemantic(diffs)
            expect(diffs).to eq([Diff.new(:delete, 'abcd'), Diff.new(:equal, '1212'), Diff.new(:insert, 'efghi'),Diff.new(:equal, '----'), Diff.new(:delete, 'A'), Diff.new(:equal, '3'),Diff.new(:insert, 'BC')])
        end
    end
    
    describe 'Cleanup operationally trivial equalities' do
        before(:each) { dmp.diff_editCost = 4 }
        
        it 'Null case' do
            diffs = []
            dmp.diff_cleanupEfficiency(diffs)
            expect(diffs).to eq([])
        end
        
        it 'No elimination' do
            diffs = [Diff.new(:delete, 'ab'), Diff.new(:insert, '12'), Diff.new(:equal, 'wxyz'), Diff.new(:delete, 'cd'), Diff.new(:insert, '34')]
            dmp.diff_cleanupEfficiency(diffs)
            expect(diffs).to eq([Diff.new(:delete, 'ab'), Diff.new(:insert, '12'), Diff.new(:equal, 'wxyz'), Diff.new(:delete, 'cd'), Diff.new(:insert, '34')])
        end
        
        it 'Four-edit elimination' do
            diffs = [Diff.new(:delete, 'ab'), Diff.new(:insert, '12'), Diff.new(:equal, 'xyz'), Diff.new(:delete, 'cd'), Diff.new(:insert, '34')]
            dmp.diff_cleanupEfficiency(diffs)
            expect(diffs).to eq([Diff.new(:delete, 'abxyzcd'), Diff.new(:insert, '12xyz34')])
        end
        
        it 'Three-edit elimination' do
            diffs = [Diff.new(:insert, '12'), Diff.new(:equal, 'x'), Diff.new(:delete, 'cd'), Diff.new(:insert, '34')]
            dmp.diff_cleanupEfficiency(diffs)
            expect(diffs).to eq([Diff.new(:delete, 'xcd'), Diff.new(:insert, '12x34')])
        end
        
        it 'Backpass elimination' do
            diffs = [Diff.new(:delete, 'ab'), Diff.new(:insert, '12'), Diff.new(:equal, 'xy'), Diff.new(:insert, '34'), Diff.new(:equal, 'z'), Diff.new(:delete, 'cd'), Diff.new(:insert, '56')]
            dmp.diff_cleanupEfficiency(diffs)
            expect(diffs).to eq([Diff.new(:delete, 'abxyzcd'), Diff.new(:insert, '12xy34z56')])
        end
        
        it 'High cost elimination' do
            dmp.diff_editCost = 5
            diffs = [Diff.new(:delete, 'ab'), Diff.new(:insert, '12'), Diff.new(:equal, 'wxyz'), Diff.new(:delete, 'cd'), Diff.new(:insert, '34')]
            dmp.diff_cleanupEfficiency(diffs)
            expect(diffs).to eq([Diff.new(:delete, 'abwxyzcd'), Diff.new(:insert, '12wxyz34')])
        end
    end
    
    it 'Pretty print' do
        diffs = [Diff.new(:equal, 'a\n'), Diff.new(:delete, '<B>b</B>'), Diff.new(:insert, 'c&d')]
        expect(dmp.diff_prettyHtml(diffs)).to eq('<span>a&para;<br></span><del style="background:#ffe6e6;">&lt;B&gt;b&lt;/B&gt;</del><ins style="background:#e6ffe6;">c&amp;d</ins>')
    end
    
    it 'Compute the source and destination texts' do
        diffs = [
            Diff.new(:equal, 'jump'), Diff.new(:delete, 's'), Diff.new(:insert, 'ed'),
            Diff.new(:equal, ' over '), Diff.new(:delete, 'the'), Diff.new(:insert, 'a'),
            Diff.new(:equal, ' lazy')
        ]
        expect(dmp.diff_text1(diffs)).to eq('jumps over the lazy')
        expect(dmp.diff_text2(diffs)).to eq('jumped over a lazy')
    end
    
    describe 'Diff to delta' do
        it 'Convert a diff into delta string' do
            diffs = [
                Diff.new(:equal, 'jump'), Diff.new(:delete, 's'), Diff.new(:insert, 'ed'),
                Diff.new(:equal, ' over '), Diff.new(:delete, 'the'), Diff.new(:insert, 'a'),
                Diff.new(:equal, ' lazy'), Diff.new(:insert, 'old dog')
            ]
            text1 = dmp.diff_text1(diffs)
            expect(text1).to eq('jumps over the lazy')
            
            delta = dmp.diff_toDelta(diffs)
            expect(delta).to eq("=4\t-1\t+ed\t=6\t-3\t+a\t=5\t+old dog")
            
            # Convert delta string into a diff.
            expect(dmp.diff_fromDelta(text1, delta)).to eq(diffs)
            
            # Generates error (19 != 20).
            expect { dmp.diff_fromDelta(text1 + 'x', delta) }.to raise_error(ArgumentError)
            
            # Generates error (19 != 18).
            expect { dmp.diff_fromDelta(text1[1..-1], delta) }.to raise_error(ArgumentError)
        end
        
        it 'Test deltas with special characters' do
            diffs = [
                Diff.new(:equal, "\u0680 \x00 \t %"), Diff.new(:delete, "\u0681 \x01 \n ^"),
                Diff.new(:insert, "\u0682 \x02 \\ |")
            ]
            text1 = dmp.diff_text1(diffs)
            expect(text1).to eq("\u0680 \x00 \t %\u0681 \x01 \n ^")
            
            delta = dmp.diff_toDelta(diffs)
            expect( delta).to eq("=7\t-7\t+%DA%82 %02 %5C %7C")
            
            # Convert delta string into a diff.
            expect(dmp.diff_fromDelta(text1, delta)).to eq(diffs)
        end
        
        it 'Verify pool of unchanged characters' do
            diffs = [Diff.new(:insert, "A-Z a-z 0-9 - _ . ! ~ * \' ( )  / ? : @ & = + $ , # ")]
            text2 = dmp.diff_text2(diffs)
            expect(text2).to eq("A-Z a-z 0-9 - _ . ! ~ * \' ( )  / ? : @ & = + $ , # ")
            
            delta = dmp.diff_toDelta(diffs)
            expect(delta).to eq("+A-Z a-z 0-9 - _ . ! ~ * \' ( )  / ? : @ & = + $ , # ")
            
            # Convert delta string into a diff.
            expect(dmp.diff_fromDelta('', delta)).to eq(diffs)
        end
    end
    
    describe '# Translate a location in text1 to text2' do
        it 'Translation on equality' do
            diffs = [Diff.new(:delete, 'a'), Diff.new(:insert, '1234'), Diff.new(:equal, 'xyz')]
            expect(dmp.diff_xIndex(diffs, 2)).to eq(5)
        end
        
        it 'Translation on deletion' do
            diffs = [Diff.new(:equal, 'a'), Diff.new(:delete, '1234'), Diff.new(:equal, 'xyz')]
            expect(dmp.diff_xIndex(diffs, 3)).to eq(1)
        end
    end
    
    describe 'Levenshtein' do
        it 'Levenshtein with trailing equality' do
            diffs = [Diff.new(:delete, 'abc'), Diff.new(:insert, '1234'), Diff.new(:equal, 'xyz')]
            expect(dmp.diff_levenshtein(diffs)).to eq(4)
        end
        
        it 'Levenshtein with leading equality' do
            diffs = [Diff.new(:equal, 'xyz'), Diff.new(:delete, 'abc'), Diff.new(:insert, '1234')]
            expect(dmp.diff_levenshtein(diffs)).to eq(4)
        end
        
        it 'Levenshtein with middle equality' do
            diffs = [Diff.new(:delete, 'abc'), Diff.new(:equal, 'xyz'), Diff.new(:insert, '1234')]
            expect(dmp.diff_levenshtein(diffs)).to eq(7)
        end
    end
    
    describe 'Bisect' do
        it 'Normal' do
            a = 'cat'
            b = 'map'
            # Since the resulting diff hasn't been normalized, it would be ok if
            # the insertion and deletion pairs are swapped.
            # If the order changes, tweak this test as required.
            diffs = [
                Diff.new(:delete, 'c'), Diff.new(:insert, 'm'), Diff.new(:equal, 'a'),
                Diff.new(:delete, 't'), Diff.new(:insert, 'p')
            ]
            expect(dmp.diff_bisect(a, b, nil)).to eq(diffs)
        end
        
        it 'Timeout' do
            a = 'cat'
            b = 'map'
            diffs = [
                Diff.new(:delete, 'c'), Diff.new(:insert, 'm'), Diff.new(:equal, 'a'),
                Diff.new(:delete, 't'), Diff.new(:insert, 'p')
            ]
            expect(dmp.diff_bisect(a, b, Time.now - 1)).to eq([Diff.new(:delete, 'cat'), Diff.new(:insert, 'map')])
        end
    end
    
    describe 'Perform a trivial diff' do
        it 'Null case' do
            expect(dmp.diff_main('', '', false)).to eq([])
        end
        
        it 'Equality' do
            expect(dmp.diff_main('abc', 'abc', false)).to eq([Diff.new(:equal, 'abc')])
        end
        
        it 'Simple insertion' do
            expect(dmp.diff_main('abc', 'ab123c', false)).to eq([Diff.new(:equal, 'ab'), Diff.new(:insert, '123'), Diff.new(:equal, 'c')])
        end
        
        it 'Simple deletion' do
            expect(dmp.diff_main('a123bc', 'abc', false)).to eq([Diff.new(:equal, 'a'), Diff.new(:delete, '123'), Diff.new(:equal, 'bc')])
        end
        
        it 'Two insertions' do
            expect(dmp.diff_main('abc', 'a123b456c', false)).to eq([Diff.new(:equal, 'a'), Diff.new(:insert, '123'), Diff.new(:equal, 'b'),Diff.new(:insert, '456'), Diff.new(:equal, 'c')])
        end
        
        it 'Two deletions' do
            expect(dmp.diff_main('a123b456c', 'abc', false)).to eq([Diff.new(:equal, 'a'), Diff.new(:delete, '123'), Diff.new(:equal, 'b'),Diff.new(:delete, '456'), Diff.new(:equal, 'c')])
        end
        
        describe 'Perform a real diff' do
            # Switch off the timeout.
            before(:each) { dmp.diff_timeout = 0 }
            
            it 'Simple cases' do
                expect(dmp.diff_main('a', 'b', false)).to eq([Diff.new(:delete, 'a'), Diff.new(:insert, 'b')])
                
                expect(dmp.diff_main('Apples are a fruit.', 'Bananas are also fruit.', false)).to eq([Diff.new(:delete, 'Apple'), Diff.new(:insert, 'Banana'),Diff.new(:equal, 's are a'), Diff.new(:insert, 'lso'),Diff.new(:equal, ' fruit.')])
                
                expect(dmp.diff_main("ax\t", "\u0680x\0", false)).to eq([Diff.new(:delete, 'a'), Diff.new(:insert, "\u0680"), Diff.new(:equal, 'x'),Diff.new(:delete, "\t"), Diff.new(:insert, "\0")])
            end
            
            it 'Overlaps' do
                expect(dmp.diff_main('1ayb2', 'abxab', false)).to eq([Diff.new(:delete, '1'), Diff.new(:equal, 'a'), Diff.new(:delete, 'y'),Diff.new(:equal, 'b'), Diff.new(:delete, '2'), Diff.new(:insert, 'xab')])
                
                expect(dmp.diff_main('abcy', 'xaxcxabc', false)).to eq([Diff.new(:insert, 'xaxcx'), Diff.new(:equal, 'abc'), Diff.new(:delete, 'y')])
                
                expect(
                    dmp.diff_main(
                                   'ABCDa=bcd=efghijklmnopqrsEFGHIJKLMNOefg',
                                   'a-bcd-efghijklmnopqrs',
                                   false
                                 )
                ).to eq(
                    [
                     Diff.new(:delete, 'ABCD'), Diff.new(:equal, 'a'), Diff.new(:delete, '='),
                     Diff.new(:insert, '-'), Diff.new(:equal, 'bcd'), Diff.new(:delete, '='),
                     Diff.new(:insert, '-'), Diff.new(:equal, 'efghijklmnopqrs'),
                     Diff.new(:delete, 'EFGHIJKLMNOefg')
                    ])
            end
            
            it 'Large equality' do
                expect(dmp.diff_main('a [[Pennsylvania]] and [[New', ' and [[Pennsylvania]]', false)).to eq([Diff.new(:insert, ' '), Diff.new(:equal, 'a'), Diff.new(:insert, 'nd'),Diff.new(:equal, ' [[Pennsylvania]]'), Diff.new(:delete, ' and [[New')])
            end
            
            it 'Timeout' do
                dmp.diff_timeout = 0.1  # 100ms
                a = "`Twas brillig, and the slithy toves\nDid gyre and gimble in the wabe:\nAll mimsy were the borogoves,\nAnd the mome raths outgrabe.\n"
                b = "I am the very model of a modern major general,\nI\'ve information vegetable, animal, and mineral,\nI know the kings of England, and I quote the fights historical,\nFrom Marathon to Waterloo, in order categorical.\n"
                # Increase the text lengths by 1024 times to ensure a timeout.
                a = a * 1024
                b = b * 1024
                start_time = Time.now
                dmp.diff_main(a, b)
                end_time = Time.now
                # Test that we took at least the timeout period.
                expect(end_time - start_time).to be >= dmp.diff_timeout
                # Test that we didn't take forever (be forgiving).
                # Theoretically this test could fail very occasionally if the
                # OS task swaps or locks up for a second at the wrong moment.
                expect(end_time - start_time).to be < dmp.diff_timeout * 1000 * 2
            end
            
            describe 'Linemode speedup' do
                before(:each) { dmp.diff_timeout = 0 }
                
                it 'Simple line-mode' do
                    a = "1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n"
                    b = "abcdefghij\nabcdefghij\nabcdefghij\nabcdefghij\nabcdefghij\nabcdefghij\nabcdefghij\nabcdefghij\nabcdefghij\nabcdefghij\nabcdefghij\nabcdefghij\nabcdefghij\n"
                    expect(dmp.diff_main(a, b, true)).to eq(dmp.diff_main(a, b, false))
                end
                
                it 'Single line-mode' do
                    a = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
                    b = 'abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij'
                    expect(dmp.diff_main(a, b, true)).to eq(dmp.diff_main(a, b, false))
                end
                
                it 'Overlap line-mode' do
                    a = "1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n1234567890\n"
                    b = "abcdefghij\n1234567890\n1234567890\n1234567890\nabcdefghij\n1234567890\n1234567890\n1234567890\nabcdefghij\n1234567890\n1234567890\n1234567890\nabcdefghij\n"
                    
                    diffs_linemode = dmp.diff_main(a, b, true)
                    diffs_textmode = dmp.diff_main(a, b, false)
                    expect(dmp.diff_text1(diffs_textmode)).to eq(dmp.diff_text1(diffs_linemode))
                    expect(dmp.diff_text2(diffs_textmode)).to eq(dmp.diff_text2(diffs_linemode))
                end
            end

            it 'Test null inputs' do
                expect { dmp.diff_main(nil, nil) }.to raise_error(ArgumentError)
            end
        end
    end
    
    describe 'Match tests' do
        describe 'Initialise the bitmasks for Bitap' do
            it 'Unique' do
                expect(dmp.match_alphabet('abc')).to eq({'a'=>4, 'b'=>2, 'c'=>1})
            end
            
            it 'Duplicates' do
                expect(dmp.match_alphabet('abcaba')).to eq({'a'=>37, 'b'=>18, 'c'=>8})
            end
        end
        
        describe 'Bitap algorithm' do
            before(:each) do
                dmp.match_distance = 100
                dmp.match_threshold = 0.5
            end
            
            it 'Exact matches' do
                expect(dmp.match_bitap('abcdefghijk', 'fgh', 5)).to eq(5)
                
                expect(dmp.match_bitap('abcdefghijk', 'fgh', 0)).to eq(5)
            end
            
            it 'Fuzzy matches' do
                expect(dmp.match_bitap('abcdefghijk', 'efxhi', 0)).to eq(4)
                
                expect(dmp.match_bitap('abcdefghijk', 'cdefxyhijk', 5)).to eq(2)
                
                expect(dmp.match_bitap('abcdefghijk', 'bxy', 1)).to eq(nil)
            end
            
            it 'Overflow' do
                expect(dmp.match_bitap('123456789xx0', '3456789x0', 2)).to eq(2)
            end
            
            it 'Threshold test' do
                dmp.match_threshold = 0.4
                expect(dmp.match_bitap('abcdefghijk', 'efxyhi', 1)).to eq(4)
                
                dmp.match_threshold = 0.3
                expect(dmp.match_bitap('abcdefghijk', 'efxyhi', 1)).to eq(nil)
                
                dmp.match_threshold = 0.0
                expect(dmp.match_bitap('abcdefghijk', 'bcdef', 1)).to eq(1)
            end
            
            it 'Multiple select' do
                expect(dmp.match_bitap('abcdexyzabcde', 'abccde', 3)).to eq(0)
                
                expect(dmp.match_bitap('abcdexyzabcde', 'abccde', 5)).to eq(8)
            end
            
            it 'Distance test' do
                dmp.match_distance = 10  # Strict location.
                expect(dmp.match_bitap('abcdefghijklmnopqrstuvwxyz', 'abcdefg', 24)).to eq(nil)
                
                expect(dmp.match_bitap('abcdefghijklmnopqrstuvwxyz', 'abcdxxefg', 1)).to eq(0)
                
                dmp.match_distance = 1000  # Loose location.
                expect(dmp.match_bitap('abcdefghijklmnopqrstuvwxyz', 'abcdefg', 24)).to eq(0)
            end
        end
    
        describe 'Full match' do
            it 'Shortcut matches' do
                expect(dmp.match_main('abcdef', 'abcdef', 1000)).to eq(0)
                
                expect(dmp.match_main('', 'abcdef', 1)).to eq(nil)
                
                expect(dmp.match_main('abcdef', '', 3)).to eq(3)
                
                expect(dmp.match_main('abcdef', 'de', 3)).to eq(3)
            end
            
            it 'Beyond end match' do
                expect(dmp.match_main("abcdef", "defy", 4)).to eq(3)
            end
            
            it 'Oversized pattern' do
                expect(dmp.match_main("abcdef", "abcdefy", 0)).to eq(0)
            end
            
            it 'Complex match' do
                expect(dmp.match_main('I am the very model of a modern major general.', ' that berry ', 5)).to eq(4)
            end
            
            it 'Test null inputs' do
                expect { dmp.match_main(nil, nil, 0) }.to raise_error(ArgumentError)
            end
        end
    end
    
    describe 'Patch tests' do
        it 'Patch Object' do
            p = Patch.new
            p.start1 = 20
            p.start2 = 21
            p.length1 = 18
            p.length2 = 17
            p.diffs = [
                Diff.new(:equal, 'jump'),
                Diff.new(:delete, 's'),
                Diff.new(:insert, 'ed'),
                Diff.new(:equal, ' over '),
                Diff.new(:delete, 'the'),
                Diff.new(:insert, 'a'),
                Diff.new(:equal, "\nlaz")
            ]
            strp = p.to_s
            expect(strp).to eq("@@ -21,18 +22,17 @@\n jump\n-s\n+ed\n  over \n-the\n+a\n %0Alaz\n")
        end
        
        it 'Patch from text' do
            expect(dmp.patch_fromText("")).to eq([])
            
            [
                "@@ -21,18 +22,17 @@\n jump\n-s\n+ed\n  over \n-the\n+a\n %0Alaz\n",
                "@@ -1 +1 @@\n-a\n+b\n",
                "@@ -1 +1 @@\n-a\n+b\n",
                "@@ -0,0 +1,3 @@\n+abc\n"
            ].each do |strp|
                expect(dmp.patch_fromText(strp).first.to_s).to eq(strp)
            end
            
            # Generates error.
            expect { dmp.patch_fromText('Bad\nPatch\n') }.to raise_error(ArgumentError)
        end
        
        it 'Patch to text' do
            [
                "@@ -21,18 +22,17 @@\n jump\n-s\n+ed\n  over \n-the\n+a\n  laz\n",
                "@@ -1,9 +1,9 @@\n-f\n+F\n oo+fooba\n@@ -7,9 +7,9 @@\n obar\n-,\n+.\n  tes\n"
            ].each do |strp|
                p = dmp.patch_fromText(strp)
                expect(dmp.patch_toText(p)).to eq(strp)
            end
        end
        
        describe 'Patch addText' do
            before(:each) { dmp.patch_margin = 4 }
            it 'Normal' do
                p = dmp.patch_fromText("@@ -21,4 +21,10 @@\n-jump\n+somersault\n").first
                dmp.patch_addContext(p, 'The quick brown fox jumps over the lazy dog.')
                expect(p.to_s).to eq("@@ -17,12 +17,18 @@\n fox \n-jump\n+somersault\n s ov\n")
            end
            
            it 'Not enough trailing context' do
                p = dmp.patch_fromText("@@ -21,4 +21,10 @@\n-jump\n+somersault\n").first
                dmp.patch_addContext(p, 'The quick brown fox jumps.')
                expect(p.to_s).to eq("@@ -17,10 +17,16 @@\n fox \n-jump\n+somersault\n s.\n")
            end
            
            it 'Not enough leading context' do
                p = dmp.patch_fromText("@@ -3 +3,2 @@\n-e\n+at\n").first
                dmp.patch_addContext(p, 'The quick brown fox jumps.')
                expect(p.to_s).to eq("@@ -1,7 +1,8 @@\n Th\n-e\n+at\n  qui\n")
            end
            
            it 'With ambiguity' do
                p = dmp.patch_fromText("@@ -3 +3,2 @@\n-e\n+at\n").first
                dmp.patch_addContext(p, 'The quick brown fox jumps.  The quick brown fox crashes.');
                expect(p.to_s).to eq("@@ -1,27 +1,28 @@\n Th\n-e\n+at\n  quick brown fox jumps. \n")
            end
        end

        describe 'Patch make ' do
            subject(:text1) { 'The quick brown fox jumps over the lazy dog.' }
            subject(:text2) { 'That quick brown fox jumped over a lazy dog.' }
            
            it 'Null case' do
                patches = dmp.patch_make('', '')
                expect(dmp.patch_toText(patches)).to eq('')
            end
            
            it 'Text2+Text1 inputs' do
                expectedPatch = "@@ -1,8 +1,7 @@\n Th\n-at\n+e\n  qui\n@@ -21,17 +21,18 @@\n jump\n-ed\n+s\n  over \n-a\n+the\n  laz\n"
                # The second patch must be "-21,17 +21,18", not "-22,17 +21,18" due to rolling context
                patches = dmp.patch_make(text2, text1)
                expect(dmp.patch_toText(patches)).to eq(expectedPatch)
            end
            
            it 'Text1+Text2 inputs' do
                expectedPatch = "@@ -1,11 +1,12 @@\n Th\n-e\n+at\n  quick b\n@@ -22,18 +22,17 @@\n jump\n-s\n+ed\n  over \n-the\n+a\n  laz\n"
                patches = dmp.patch_make(text1, text2)
                expect(dmp.patch_toText(patches)).to eq(expectedPatch)
            end
            
            it 'Diff input' do
                expectedPatch = "@@ -1,11 +1,12 @@\n Th\n-e\n+at\n  quick b\n@@ -22,18 +22,17 @@\n jump\n-s\n+ed\n  over \n-the\n+a\n  laz\n"
                diffs = dmp.diff_main(text1, text2, false)
                patches = dmp.patch_make(diffs)
                expect(dmp.patch_toText(patches)).to eq(expectedPatch)
            end
            
            it 'Text1+Diff inputs' do
                expectedPatch = "@@ -1,11 +1,12 @@\n Th\n-e\n+at\n  quick b\n@@ -22,18 +22,17 @@\n jump\n-s\n+ed\n  over \n-the\n+a\n  laz\n"
                diffs = dmp.diff_main(text1, text2, false)
                patches = dmp.patch_make(text1, diffs)
                expect(dmp.patch_toText(patches)).to eq(expectedPatch)
            end
            
            it 'Text1+Text2+Diff inputs (deprecated)' do
                expectedPatch = "@@ -1,11 +1,12 @@\n Th\n-e\n+at\n  quick b\n@@ -22,18 +22,17 @@\n jump\n-s\n+ed\n  over \n-the\n+a\n  laz\n"
                diffs = dmp.diff_main(text1, text2, false)
                patches = dmp.patch_make(text1, text2, diffs)
                expect(dmp.patch_toText(patches)).to eq(expectedPatch)
            end
            
            it 'Character encoding' do
                patches = dmp.patch_make('`1234567890-=[]\\;\',./', '~!@#$%^&*()_+{}|:"<>?')
                expect(dmp.patch_toText(patches)).to eq("@@ -1,21 +1,21 @@\n-%601234567890-=%5B%5D%5C;\',./\n+~!@\#$%25%5E&*()_+%7B%7D%7C:%22%3C%3E?\n")
            end
            
            it 'Character decoding' do
                diffs = [
                    Diff.new(:delete, '`1234567890-=[]\\;\',./'),
                    Diff.new(:insert, '~!@#$%^&*()_+{}|:"<>?')
                ]
                expect(dmp.patch_fromText(
                        "@@ -1,21 +1,21 @@\n-%601234567890-=%5B%5D%5C;\',./\n+~!@\#$%25%5E&*()_+%7B%7D%7C:%22%3C%3E?\n"
                       ).first.diffs
                ).to eq(diffs)
            end
            
            it 'Long string with repeats' do
                text1 = 'abcdef' * 100
                text2 = text1 + '123'
                expectedPatch = "@@ -573,28 +573,31 @@\n cdefabcdefabcdefabcdefabcdef\n+123\n"
                patches = dmp.patch_make(text1, text2)
                expect(dmp.patch_toText(patches)).to eq(expectedPatch)
            end
            
            it 'Test null inputs' do
                expect { dmp.patch_make(nil) }.to raise_error(ArgumentError)
            end
        end
        
        describe 'Patch splitMax' do
            it 'case 1' do
                patches = dmp.patch_make('abcdefghijklmnopqrstuvwxyz01234567890', 'XabXcdXefXghXijXklXmnXopXqrXstXuvXwxXyzX01X23X45X67X89X0')
                dmp.patch_splitMax(patches)
                expect(dmp.patch_toText(patches)).to eq("@@ -1,32 +1,46 @@\n+X\n ab\n+X\n cd\n+X\n ef\n+X\n gh\n+X\n ij\n+X\n kl\n+X\n mn\n+X\n op\n+X\n qr\n+X\n st\n+X\n uv\n+X\n wx\n+X\n yz\n+X\n 012345\n@@ -25,13 +39,18 @@\n zX01\n+X\n 23\n+X\n 45\n+X\n 67\n+X\n 89\n+X\n 0\n")
            end
            
            it 'case 2' do
                patches = dmp.patch_make('abcdef1234567890123456789012345678901234567890123456789012345678901234567890uvwxyz', 'abcdefuvwxyz')
                oldToText = dmp.patch_toText(patches)
                dmp.patch_splitMax(patches)
                expect(dmp.patch_toText(patches)).to eq(oldToText)
            end
            
            it 'case 3' do
                patches = dmp.patch_make('1234567890123456789012345678901234567890123456789012345678901234567890', 'abc')
                dmp.patch_splitMax(patches)
                expect(dmp.patch_toText(patches)).to eq("@@ -1,32 +1,4 @@\n-1234567890123456789012345678\n 9012\n@@ -29,32 +1,4 @@\n-9012345678901234567890123456\n 7890\n@@ -57,14 +1,3 @@\n-78901234567890\n+abc\n")
            end
            
            it 'case 4' do
                patches = dmp.patch_make('abcdefghij , h : 0 , t : 1 abcdefghij , h : 0 , t : 1 abcdefghij , h : 0 , t : 1', 'abcdefghij , h : 1 , t : 1 abcdefghij , h : 1 , t : 1 abcdefghij , h : 0 , t : 1')
                dmp.patch_splitMax(patches)
                expect(dmp.patch_toText(patches)).to eq("@@ -2,32 +2,32 @@\n bcdefghij , h : \n-0\n+1\n  , t : 1 abcdef\n@@ -29,32 +29,32 @@\n bcdefghij , h : \n-0\n+1\n  , t : 1 abcdef\n")
            end
        end
        
        describe 'Patch_addPadding' do
            it 'Both edges full' do
                patches = dmp.patch_make('', 'test')
                expect(dmp.patch_toText(patches)).to eq("@@ -0,0 +1,4 @@\n+test\n")
                dmp.patch_addPadding(patches)
                expect(dmp.patch_toText(patches)).to eq("@@ -1,8 +1,12 @@\n %01%02%03%04\n+test\n %01%02%03%04\n")
            end
            
            it 'Both edges partial' do
                patches = dmp.patch_make('XY', 'XtestY')
                expect(dmp.patch_toText(patches)).to eq("@@ -1,2 +1,6 @@\n X\n+test\n Y\n")
                dmp.patch_addPadding(patches)
                expect(dmp.patch_toText(patches)).to eq("@@ -2,8 +2,12 @@\n %02%03%04X\n+test\n Y%01%02%03\n")
            end
            
            it 'Both edges none' do
                patches = dmp.patch_make('XXXXYYYY', 'XXXXtestYYYY')
                expect(dmp.patch_toText(patches)).to eq("@@ -1,8 +1,12 @@\n XXXX\n+test\n YYYY\n")
                dmp.patch_addPadding(patches)
                expect(dmp.patch_toText(patches)).to eq("@@ -5,8 +5,12 @@\n XXXX\n+test\n YYYY\n")
            end
        end
        
        describe 'Patch apply' do
            before(:each) do
                dmp.match_distance = 1000
                dmp.match_threshold = 0.5
                dmp.patch_deleteThreshold = 0.5
            end
            
            it 'Null case' do
                patches = dmp.patch_make('', '')
                results = dmp.patch_apply(patches, 'Hello world.')
                expect(results).to eq(['Hello world.', []])
            end
            
            it 'Exact match' do
                patches = dmp.patch_make('The quick brown fox jumps over the lazy dog.', 'That quick brown fox jumped over a lazy dog.')
                results = dmp.patch_apply(patches, 'The quick brown fox jumps over the lazy dog.')
                expect(results).to eq(['That quick brown fox jumped over a lazy dog.', [true, true]])
            end
            
            it 'Partial match' do
                patches = dmp.patch_make('The quick brown fox jumps over the lazy dog.', 'That quick brown fox jumped over a lazy dog.')
                results = dmp.patch_apply(patches, 'The quick red rabbit jumps over the tired tiger.')
                expect(results).to eq(['That quick red rabbit jumped over a tired tiger.', [true, true]])
            end
            
            it 'Failed match' do
                patches = dmp.patch_make('The quick brown fox jumps over the lazy dog.', 'That quick brown fox jumped over a lazy dog.')
                results = dmp.patch_apply(patches, 'I am the very model of a modern major general.')
                expect(results).to eq(['I am the very model of a modern major general.', [false, false]])
            end
            
            it 'Big delete, small change' do
                patches = dmp.patch_make('x1234567890123456789012345678901234567890123456789012345678901234567890y', 'xabcy')
                results = dmp.patch_apply(patches, 'x123456789012345678901234567890-----++++++++++-----123456789012345678901234567890y')
                expect(results).to eq(['xabcy', [true, true]])
            end
            
            it 'Big delete, big change 1' do
                patches = dmp.patch_make('x1234567890123456789012345678901234567890123456789012345678901234567890y', 'xabcy')
                results = dmp.patch_apply(patches, 'x12345678901234567890---------------++++++++++---------------12345678901234567890y')
                expect(results).to eq(['xabc12345678901234567890---------------++++++++++---------------12345678901234567890y', [false, true]])
            end
            
            it 'Big delete, big change 2' do
                dmp.patch_deleteThreshold = 0.6
                patches = dmp.patch_make('x1234567890123456789012345678901234567890123456789012345678901234567890y', 'xabcy')
                results = dmp.patch_apply(patches, 'x12345678901234567890---------------++++++++++---------------12345678901234567890y')
                expect(results).to eq(['xabcy', [true, true]])
            end
            
            it 'Compensate for failed patch' do
                dmp.match_threshold = 0.0
                dmp.match_distance = 0
                patches = dmp.patch_make('abcdefghijklmnopqrstuvwxyz--------------------1234567890', 'abcXXXXXXXXXXdefghijklmnopqrstuvwxyz--------------------1234567YYYYYYYYYY890')
                results = dmp.patch_apply(patches, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ--------------------1234567890')
                expect(results).to eq(['ABCDEFGHIJKLMNOPQRSTUVWXYZ--------------------1234567YYYYYYYYYY890', [false, true]])
            end
            
            it 'No side effects' do
                patches = dmp.patch_make('', 'test')
                patchstr = dmp.patch_toText(patches)
                dmp.patch_apply(patches, '')
                expect(dmp.patch_toText(patches)).to eq(patchstr)
            end
            
            it 'No side effects with major delete' do
                patches = dmp.patch_make('The quick brown fox jumps over the lazy dog.', 'Woof')
                patchstr = dmp.patch_toText(patches)
                dmp.patch_apply(patches, 'The quick brown fox jumps over the lazy dog.')
                expect(dmp.patch_toText(patches)).to eq(patchstr)
            end
            
            it 'Edge exact match' do
                patches = dmp.patch_make('', 'test')
                results = dmp.patch_apply(patches, '')
                expect(results).to eq(['test', [true]])
            end
            
            it 'Near edge exact match' do
                patches = dmp.patch_make('XY', 'XtestY')
                results = dmp.patch_apply(patches, 'XY')
                expect(results).to eq(['XtestY', [true]])
            end
            
            it 'Edge partial match' do
                patches = dmp.patch_make('y', 'y123')
                results = dmp.patch_apply(patches, 'x')
                expect(results).to eq(['x123', [true]])
            end
        end
    end

    it 'Correct patching' do
        text1 = File.read "#{File.dirname __FILE__}/assets/persona_v1.java"
        text2 = File.read "#{File.dirname __FILE__}/assets/persona_v2.java"
        diffs = dmp.diff_main(text1, text2)
        patches = dmp.patch_make(diffs)
        expect(dmp.patch_apply(patches, text1)[0]).to eq(text2)
    end
            
end
