# Hidden-Text:

</br>

![Compiler](https://github.com/user-attachments/assets/a916143d-3f1b-4e1f-b1e0-1067ef9e0401) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: ![10 Seattle](https://github.com/user-attachments/assets/c70b7f21-688a-4239-87c9-9a03a8ff25ab) ![10 1 Berlin](https://github.com/user-attachments/assets/bdcd48fc-9f09-4830-b82e-d38c20492362) ![10 2 Tokyo](https://github.com/user-attachments/assets/5bdb9f86-7f44-4f7e-aed2-dd08de170bd5) ![10 3 Rio](https://github.com/user-attachments/assets/e7d09817-54b6-4d71-a373-22ee179cd49c)   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;![10 4 Sydney](https://github.com/user-attachments/assets/e75342ca-1e24-4a7e-8fe3-ce22f307d881) ![11 Alexandria](https://github.com/user-attachments/assets/64f150d0-286a-4edd-acab-9f77f92d68ad) ![12 Athens](https://github.com/user-attachments/assets/59700807-6abf-4e6d-9439-5dc70fc0ceca)  
![Components](https://github.com/user-attachments/assets/d6a7a7a4-f10e-4df1-9c4f-b4a1a8db7f0e) : ![UEncrypt pas](https://github.com/user-attachments/assets/132798a4-f565-48c3-9b1f-04cd2705c0e2)  
![Discription](https://github.com/user-attachments/assets/4a778202-1072-463a-bfa3-842226e300af) &nbsp;&nbsp;: ![Hidden Text](https://github.com/user-attachments/assets/3a5c5260-5a0c-42a5-8bf9-87675c635878)
![Last Update](https://github.com/user-attachments/assets/e1d05f21-2a01-4ecf-94f3-b7bdff4d44dd) &nbsp;: ![102025](https://github.com/user-attachments/assets/62cea8cc-bd7d-49bd-b920-5590016735c0)  
![License](https://github.com/user-attachments/assets/ff71a38b-8813-4a79-8774-09a2f3893b48) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: ![Freeware](https://github.com/user-attachments/assets/1fea2bbf-b296-4152-badd-e1cdae115c43)

</br>

Steganography is the practice of representing information within another message or physical object, in such a manner that the presence of the concealed information would not be evident to an unsuspecting person's examination. In computing/electronic contexts, a computer file, message, image, or video is concealed within another file, message, image, or video. Generally, the hidden messages appear to be (or to be part of) something else: images, articles, shopping lists, or some other cover text. For example, the hidden message may be in invisible ink between the visible lines of a private letter. Some implementations of steganography that lack a formal shared secret are forms of security through obscurity, while key-dependent steganographic schemes try to adhere to [Kerckhoffs's principle](https://en.wikipedia.org/wiki/Kerckhoffs%27s_principle).

### A bitmap should be loaded and it must be in 24-bit format.

</br>

![Hidden Taxt](https://github.com/user-attachments/assets/ba9e03cd-1acf-4b02-b420-17685b1fd2b4)

</br>

Since the dawn of computers, techniques have been developed to embed messages in digital cover mediums. The message to conceal is often encrypted, then used to overwrite part of a much larger block of encrypted data or a block of random data (an unbreakable cipher like the [one-time pad](https://en.wikipedia.org/wiki/One-time_pad) generates ciphertexts that look perfectly random without the private key).

### How digital steganography works:
* Digital [steganography](https://en.wikipedia.org/wiki/Steganography) uses a "cover" file to carry the hidden message. Common cover media include images, audio, video, or text. The secret message, sometimes encrypted for added security, is embedded by modifying the cover file in subtle ways that are typically imperceptible to a human observer. 
* A prevalent technique is Least [Significant Bit (LSB)](https://en.wikipedia.org/wiki/Bit_numbering) steganography, which operates as follows: 
    * Bit modification: Digital files are made of bytes. For each byte, the least significant bit (the last bit) can be changed without making a visually or audibly noticeable difference.
    * Embedding data: A secret message is encoded into these LSBs. For example, in an image, a hidden message can be embedded in the LSBs of each pixel's color values (red, green, and blue).
    * Resulting stego-object: The original file becomes a "stego-object" containing the hidden message. The recipient, who knows the technique and any necessary key, can extract the concealed information.

### Encryption:
But here, not only is the information hidden, but it's also encrypted. Should an outsider gain access to the hidden text, they will find that they can't read it unless they have the passkey and the encryption algorithm.

* Crypter Algorithm

```pascal
function Crypter(const S: AnsiString): AnsiString;
const
  Map: array[AnsiChar] of Byte = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 63, 52, 53,
    54, 55, 56, 57, 58, 59, 60, 61, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2,
    3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
    20, 21, 22, 23, 24, 25, 0, 0, 0, 0, 0, 0, 26, 27, 28, 29, 30,
    31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
    46, 47, 48, 49, 50, 51, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0
  );
var
  I: LongInt;
begin
  case Length(S) of
    2:
    begin
      I := Map[S[1]] + (Map[S[2]] shl 6);
      SetLength(Result, 1);
      Move(I, Result[1], Length(Result))
    end;
    3:
    begin
      I := Map[S[1]] + (Map[S[2]] shl 6) + (Map[S[3]] shl 12);
      SetLength(Result, 2);
      Move(I, Result[1], Length(Result))
    end;
    4:
    begin
      I := Map[S[1]] + (Map[S[2]] shl 6) + (Map[S[3]] shl 12) +
        (Map[S[4]] shl 18);
      SetLength(Result, 3);
      Move(I, Result[1], Length(Result))
    end;
  end;
end;
```

</br>

### Anyone can implement their own string encryptor. However, it should be equipped with a passkey to make it significantly more difficult to view the text.
