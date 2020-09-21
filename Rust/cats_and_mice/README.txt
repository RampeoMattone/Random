Gioco basato sulla falsa riga di shar-o.
Questo file descrive le dinamiche di gioco e il progetto è quello di un server scritto in rust per la gestione degli
input provenienti da client.
regole:
 - 4 giocatori
 - griglia 10*10
 - start del round: 4 posizioni prese a caso sulla griglia e associate a un giocatore (una per giocatore)
 - ogni giocatore "segue" il successivo a partire dal seguente schema circolare --->1-2-3-4--->
     In breve: il giocatore 1 si muove attorno alla mossa precedente del giocatore 2.
 - i round sono fatti in contemporanea tra tutti i giocatori. le mosse non vengono concatenate tra
   i 4 ma avvengono in parallelo.
 - un giocatore muore se non ha lati diretti (spiegati dopo) liberi.
 - alla morte di un giocatore il suo inseguitore inizierà a seguire il giocatore seguito dall'ormai defunto inseguito.
   es: 1->2->3->4->1, muore 2 => 1->3->4->1 (-> = "segue")
 schema di movimento:
     - - - - - - - - - -
     - - - - - - - - - -
     - - - - - - - - - -
     - - o * o - - - - -     >> "centro di mossa" (X)
     - - * X * - - - - -     >> lati diretti (*)
     - - o * o - - - - -     >> lati indiretti (o)
     - - - - - - - - - -     >> lato irrilevante (-)
     - - - - - - - - - -
     - - - - - - - - - -
     - - - - - - - - - -
 a partire dal "centro di mossa" si controllano quali tra le 8 caselle che lo circondano sono libere. Tra le caselle
 libere distinguiamo i lati diretti e quelli indiretti.
 I lati diretti (a meno che occupati o in contesa) sono sempre raggiungibili.
 I lati indiretti sono raggiungibili solo se almeno uno dei lati diretti a loro adiacenti è libero un lato si dice in
 contesa se 2 o più giocatori lo possono vedere come possibile mossa. i lati contesi sono da segnalare ai giocatori come
 lati irraggiungibili.
 Se un lato indiretto dipende da un lato conteso esso non è da considerarsi irraggiungibile (a meno che anche
 esso stesso non sia conteso).

 possibile algoritmo di scelta dei lati liberi:
     1 - estraggo dalla matrice delle caselle occupate i centri di mossa e le caselle adiacenti che
         figurano come libere. questi dati vengono copiati all'interno di una matrice delle dimensioni ma con valori
         inizalizzati a 0. si consiglia l'uso di enumerazioni:
             vuoto
             centro
             possibile(condivisioni = 0)
     2 - per ogni centro di mossa si analizzano le 8 caselle adiacenti, incrementando di uno il valore di condivisioni
         qualora queste fossero di tipo "possibile"
     3 - ogni casella con un contatore di condivisioni > 1 viene segnata come vuota perché contesa
     4 - si guardano ora i lati indiretti possibili: se almeno un lato diretto da cui dipendono è possibile
         allora sono da considerarsi possibili anche questi.
         OSSERVAZIONE - il processo per il controllo è raffinabile:
           - se un centro di mossa ha almeno 3 lati diretti possibili, allora il controllo dei lati indiretti è inutile;
           - se un centro di mossa ha 2 lati diretti con ordinata o ascissa condivisa (aka stessa riga o colonna) allora
             il controllo dei lati indiretti è inutile;
           - se un centro di mossa ha 2 lati diretti con un angolo in comune allora bisogna solamente eliminare il
             lato indiretto opposto al lato indiretto che questi hanno in comune;
           - se un centro di mossa ha 1 solo lato diretto avrò al massimo 2 lati indiretti da controllare.
     5 - fine dell'algoritmo. tutte le caselle segnate come possibili lo sono di fatto.