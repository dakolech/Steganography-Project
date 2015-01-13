Steganography-Project "**CATS ARE GREAT**"
===========================

1. Wstęp
-------------------------

Naszym zadaniem było stworzenie komunikatora wykorzystującego steganografię. Jest to program, w którym wiadomości ukryte są w obrazkach przesyłanych miedzy klientem a serwerem.
Część sieciowa jest obsługiwana przez sockety, serwer jest napisany w C, a klient w Ruby z pomocą platformy Shoes do tworzenia GUI.


2. Ukrywanie wiadomości
-------------------------

* **4-cyfrowe numery do identyfikacji użytkowników i logowania (id oraz hasło)**

	Przykładowy numer: 1234, klucz: bezlitosny2
	
	Posiadamy dużą bazę imion i nazwisk. Mamy 4 cyfry, każdą ukrywamy w imieniu lub nazwisku według klucza. 2 w kluczu oznacza, że cyfry ukrywamy na trzecim miejscu w wyrazie (liczymy od zera).
	
	1 oznacza, że pierwsze imię powinno mieć na trzecim miejscu literę e (według klucza: 0-B, 1-E, 2-Z, 3-L, 4-I itd.). Pierwszym imieniem może być na przykład: ALEX. 
	
	Analogicznie robimy dla 2, ale teraz nazwisko, które posiada na trzecim miejscu literę Z, na przykład: BOZEMAN. 
	
	Teraz wybieramy czasownik oznaczający akcję: LOVES - wysłanie loginu, LIKES - wysłanie hasła, HATES - wysłanie do serwera id użytkownika do którego wysyłamy wiadomość.
	
	Załóżmy, że wysyłamy hasło, czyli wybieramy LIKES.
	
	Teraz podobnie generujemy imię i nazwisko dla 3 i 4, czyli na trzecim miejscu znajdują się L oraz I, na przykład: AILEEN BRICE.
	
	Całe zdanie wygląda następująco: ALEX BOZEMAN LIKES  AILEEN BRICE. A prawdziwe znaczenie to: klient wysyła do serwera hasło 1234 podczas logowania.
	
	

* **czynności klienta/serwera**

	Każdą czynność jaką chce wykonać klient lub serwer kodujemy za pomocą prostego, trzywyrazowego zdania, gdzie czasownik opisuje akcję:
	>	IS - poprawne logowanie
	
	>	ARE - niepoprawne dane logowania
	
	>	HAVE - oznacza, że serwer ma do wysłania wiadomości (obrazki) do klienta
	
	>	HAS - serwer nie ma co wysłać do klienta
	
	>	WAS - klient chce odebrać wiadomości
	
	>	WERE - klient chce wysłać wiadomość
	
	>	HADNT - id użytkownika, do którego klient chce wysłać wiadomość jest poprawny
	
	>	HAD - niepoprawny id użytkownika, do którego klient chce wysłać wiadomość
	
	>	BELONGS - wylogowywanie
	

	Do generowania zdań posiadamy bazę przymiotników, zwierząt oraz części ciała, aby zdania były poprawne stylistycznie. Są one jednak losowane.
	
	Dla przykładu:
	>	CAT IS BLACK. - klient poprawnie się zalogował
	
	>	I HAVE BELLY - serwer chce wysłać wiadomości do klienta
	
	>	FROGS WERE FAT - klient zgłasza gotowość do wysłania wiadomości.



* **wiadomość ukryta w obrazku**

    Wiadomości wymieniane przez użytkowników komunikatora szyfrowane są w obrazkach kotów. Klient posiada możliwość wybrania katalogu z obrazkami, z których za każdym razem przed wysłaniem wiadomości losowany będzie jeden obrazek (o rozszerzeniu .png). Szyfrowaniem oraz rozszyfrowywaniem obrazków zajmuje się klient. W obrazku zaszyfrowane są:
    *   klucz, bedący 9-cyfrową liczbą naturalną [lewy górny róg, kwadrat 3x3 piksele]
    *   timestamp, składający się z 13 cyfr, oznaczający dokładną datę preparowania obrazka (podana w czasie uniksowym, z dokładnością do 1 ms) [część w lewym górnym, część w prawym dolnym rogu]
    *   nadawca wiadomości, czyli 4-cyfrowy identyfikator nadawcy, tak, aby klient po odszyfrowaniu wiedział, od kogo ona pochodzi [prawy dolny róg, kwadrat 2x2 piksele]
    *   treść wiadomości, rozsiana po całym obrazku, w losowych pikselach
    
    No dobrze, nie do końca losowych. Ustalenie, w których pikselach obrazka znajduje się kolejna litera wiadomości możliwe jest za pomocą klucza. Klucz używany jest do tego, aby ustawić generator liczb pseudolosowych na określoną przez niego wartość początkową (seed). Następnie losowane są liczby z przedziału [0, image_width] oraz [0, image_height], stanowiące kolejne współrzędne pikseli, w których znajdą się kolejne litery wiadomości. Wylosowana współrzędna jest akceptowana, jeśli:
    *   dany piksel jest nadal wolny (nic wcześniej tam nie zapisaliśmy) oraz
    *   nie pochodzi z jednego z zarezerwowanych dla danych specjalnych (klucz, timestamp, nadawca) obszarów.
    
    **Jednak jak jest szyfrowana z osobna każda litera?**
    Skoro każdy piksel odpowiada znakowi, to znaczy, że z dostępnych 4 bajtów na piksel obrazka (po 1 B na kanał czerwony, zielony, niebieski i przezroczystość) musimy wygospodarować 1 bajt na literę w kodzie ASCII. 3 najbardziej znaczące bity znaku w kodzie ASCII kodowane są na 3 najmniej znaczących bitach składowej czerwonej, następne 2 bity na 2 najmniej znaczących bitach koloru zielonego i 3 najmniej znaczące bity znaku na 3 najmniej znaczących bitach koloru niebieskiego.
    
    **Dlaczego taki rozkład?**
    Ludzkie oko stosunkowo najlepiej rozróżnia kolor zielony, dlatego na stratę jego dokładności mogliśmy poświęcić najmniej bitów. Warto zauważyć, że kodowanie ma miejsce na najmniej znaczących bitach, co minimalizuje ostateczną zmianę koloru piksela z obrazka oryginalnego tak, że ludzkie oko nie jest w stanie zauważyć żadnej różnicy.
    Koniec wiadomości oznaczamy zaszyfrowując po ostatniej literze w kolejnym wylosowanym pikselu wartość 0, analogicznie do bajta zerowego, kończącego łańcuchy znaków ('\0').
    Cała magia dzieje się w programie klienta, w skrypcie class/message.rb w funkcji encode. Aby mieć pewność, że całość nie zawali, działanie algorytmu zostało zweryfikowane pomyślnym zakończeniem testów zdefiniowanych w pliku test/message_test.rb.
    
    **I po co nam to wszystko?**
    Program udowania, że wszechświatem rządzą koty. Od dziś zza swojego biurka możemy, wymieniając się ich zdjęciami z odpowiednimi personami, ustalać z Gazpromem ceny gazu dla połowy Europy. A haker i tak będzie widział tylko koty.
    
3. Komunikacja
-------------------------

Klient łączy się z serwerem za pomocą socketów, serwer tworzy nowy wątek. Klient wysyła id (LOVES), następnie hasło (LIKES). Serwer sprawdza poprawność logowania (dane w pliku txt, pierwsze id, w nstąpnej linii hasło).
Jeżeli id i hasło są niepoprawne, serwer wysyła zdanie (ARE), w drugim przypadku wysyła zdanie (IS). Następnie serwer sprawdza czy do tego klienta nie są zapisane jakieś obrazki, jeżeli tak wysyła najpierw zdanie (HAVE), rozmiar pliku (jawnie) i sam obrazek, jeden.
Sprawdza aż wyśle wszystkie, jeżeli nie ma już obrazków, serwer wysyła zdanie (HAS). Teraz klient steruje komunikacją. Może wysłać zdanie (BELONGS), dzięki czemu następuje koniec komunikacji, zdanie (WAS), serwer ponownie sprawdza czy są jakieś obrazki do wysłania lub zdanie (WERE), czyli klient chce wysłać obrazek.
W ostatnim przypadku po wysłaniu wiadomości (WERE), klient wysyła id (HATES), do którego chce wysłać obrazek. Serwer sprawdza jego poprawność i wysyła zdanie (HAD) w przypadku błednego id (po tym klient może wysłać zdanie WAS, WERE, BELONGS) lub zdanie (HADNT).
Następnie klient wysyła rozmiar pliku, potem obrazek, serwer zapisuje obrazek w odpowiednim folderze, a klient ponownie może wysłać zdanie WAS, WERE albo BELONGS.

4. Wnioski
-------------------------	

Największe trudności występowały podczas komunikacji między serwerem w C, a klientem w Ruby, jednakże udało nam się je przezwyciężyć.
Sposoby na ukrywanie wiadomości zostały wymyślone przez nas. Aby założyć konto w komunikatorze, trzeba się zgłosić do administratora serwera, który poda id i hasło użytkownika oraz klucz.
Bez tych trzech rzeczy nie ma możliwości, aby klient mógł działać poprawnie. Hacker przechwytujący wiadomości przesyłanie między klientem a serwerem będzie widział tylko zdania (czasami bezsensowne) oraz obrazki.
Bez wiedzy gdzie w obrazku zaszyty jest klucz, w jaki sposób oraz jak się nim posługiwać do odczytywania kolejnych pozycji pikseli z literami zakodowanej wiadomości, nie będzie w stanie jej rozszyfrować.

