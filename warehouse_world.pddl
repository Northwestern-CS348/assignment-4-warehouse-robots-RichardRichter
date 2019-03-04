(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   (:action moveRobot
      :parameters (?r - robot ?cl - location ?ml - location)
      :precondition (and (no-robot ?ml) (connected ?ml ?cl) (at ?r ?cl))
      :effect (and (at ?r ?ml) (no-robot ?cl))
   )
   (:action moveRobotWithPallette
      :parameters (?r - robot ?p - pallette ?cl - location ?ml - location)
      :precondition (and (no-robot ?ml) (no-pallette ?ml)(at ?r ?cl) (at ?p ?cl)(connected ?cl ?ml))
      :effect (and (at ?r ?ml) (at ?p ?ml) (has ?r ?p) (no-robot ?cl) (no-pallette ?cl))
   )
   (:action moveToPackagingLocation
      :parameters (?p - pallette ?cl - location ?sh - shipment ?sa - saleitem ?o - order)
      :precondition (and (started ?sh) (at ?p ?cl) (contains ?p ?sa) (orders ?o ?sa) (packing-at ?sh ?cl) (ships ?sh ?o))
      :effect (and (not (contains ?p ?sa)) (includes ?sh ?sa))
   )
   (:action completeShipment
      :parameters (?cl - location ?sh - shipment ?o - order)
      :precondition (and (started ?sh) (ships ?sh ?o) (packing-at ?sh ?cl))
      :effect (and (available ?cl) (complete ?sh))
    )
    )