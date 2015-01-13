Steganography-Project
===========================

1. Wstęp
-------------------------

	Naszym zadaniem było stworzenie komunikatora wykorzystującego steganografię. Jest to program, w którym wiadomości ukryte są w obrazkach przesyłanych miedzy klientem a serwerem.
	Część sieciowa jest obsługiwana przez Sockety, Serwer jest napisany w C, a klient w Ruby z pomocą Shoes do tworzenia GUI.


2. Ukrywanie wiadomości
-------------------------

	* 4-cyfrowe numery do identyfikacji użytkowników i logowania (id oraz hasło)
		Przykładowy numer: 1234, klucz: bezlitosny2
		Posiadamy dużą bazę immion i nazwisk. Mamy 4 cyfry, każdą ukrywamy w imię lub nazwisku według klucza. 2 w kluczu oznacza, że cyfry ukrywamy na trzecim miejscu w wyrazie (liczymy od zera).
		1 oznacza, że pierwsze imię powinno mieć na trzecim miejscu literę e (według klucza: 0-B, 1-E, 2-Z, 3-L, 4-I itd.). Pierwszym imieniem może być na przykład: ALEX. 
		Analogicznie robimy dla 2, ale teraz nazwisko, które posiada na trzecim miejscu literę Z, na przykład: BOZEMAN. 
		Teraz wybieramy czasownik oznaczający akcję: LOVES - wysłanie loginu, LIKES - wysłanie hasła, HATES - wysłanie do serwera id użytkownika do którego wysyłamy wiadomość.
		Załóżmy, że wysyłamy hasło, czyli wybieramy LIKES.
		Teraz podobnie generujemy imię i nazwisko dla 3 i 4, czyli na trzecim miejscu znajdują się L oraz I, na przykład: AILEEN BRICE.
		Całe zdanie wygląda następująco: ALEX BOZEMAN LIKES  AILEEN BRICE. A prawdziwe zanczenie to: klient wysyła do serwera hasło 1234 podczas logowania.

	* czynności klienta/serwera
		Każdą czynność jaką chce wykonać klient lub serwer kodujemy za pomocą prostego, trzywyrazowego zdania, gdzie czasownik opisuje akcję:
			IS - poprawne logowanie
			ARE - niepoprawne logowania
			HAVE - oznacza, że serwer ma do wysłania wiadomośći (obrazki) do klienta
			HAS - serwer nie ma co wysłać do klienta
			WAS - klient chce odebrać wiadomości
			WERE - klient chce wysłać wiadomość
			HADNT - id do którego klient chce wysłać wiadomość jest poprawny
			HAD - niepoprawny id do którego klient chce wysłać wiadomość
			BELONGS - wylogowywanie

		Do generowania zdań posiadamy bazę przymiotników, zwierząt oraz części ciała, aby zdania były poprawne stylistycznie. Są one jednak losowane.
		Dla przykładu:
			Cat IS BLACK. - klient poprawnie się zalogował
			I HAVE BELLY - serwer chce wysłać wiadomości do klienta
			FROGS WERE FAT - klient zgłasza gotowość do wysłania wiadomości.

	* wiadomość ukryta w obrazku


3. Komunikacja
-------------------------

	Klient łączy się z serwerem za pomocą socketów, serwer tworzy nowy wątek. Klient wysyła id (LOVES), następnie hasło (LIKES). Serwer sprawdza poprawność logowania (dane w pliku txt, pierwsze id, w nstąpnej linii hasło). 	Jeżeli id i hasło są niepoprawne, serwer wysyła zdanie (ARE), w drugim przypadku wysyła zdanie (IS). Następnie serwer sprawdza czy do tego klienta nie są zapisane jakieś obrazki, jeżeli tak wysyła najpierw zdanie (HAVE), rozmiar pliku (jawnie) i sam obrazek, jeden. Sprawdza aż wyśle wszystkie, jeżeli nie ma już obrazków, serwer wysyła zdanie (HAS). Teraz klient steruje komunikacją. Może wysłać zdanie (BELONGS), dzięki czemu następuje koniec komunikacji, zdanie (WAS), serwer ponownie sprawdza czy są jakieś obrazki do wysłania lub zdanie (WERE), czyli klient chce wysłać obrazek. W ostatnim przypadku po wysłaniu wiadomości (WERE), klient wysyła id (HATES), do którego chce wysłać obrazek. Serwer sprawdza jego poprawność i wysyła zdanie (HAD) w przypadku błednego id (po tym klient może wysłać zdanie WAS, WERE, BELONGS) lub zdanie (HADNT). Następnie klient wysyła rozmiar pliku, potem obrazek, serwer zapisuje obrazek w odpowiednim folderze, a klient ponowanie może wysła zdanie WAS, WERE albo BELONGS.

4. Wnioski
-------------------------	

	Największe trudności wsytępowały podczas komunikacji między serwerem w C, a klientem w Rubym, jednakże udało nam się je przezwyciężyć. Sposoby na ukrywanie wiadomości zostały wymyślone przez nas. Aby założyć konto w komunikatorze, trzeba się zgłośic do administratora serwera, który poda id i hasło użytkownika oraz klucz. Bez tych trzech rzeczy nie ma możliwości, aby klient mógł działać poprawnie. Hacker przechwytujący wiadomości przesyłanie między klientem a serwerem będzie widział tylko zdania (czasami bezsensowne) oraz obrazki, bez klucza nie będzie wstanie ich rozszyfrować.

