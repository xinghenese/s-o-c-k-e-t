package snappy;

/**
 * Created by kevin on 7/8/14.
 */
public class SnappyException extends RuntimeException
{
    private static final long serialVersionUID = 3546272712208105199L;

    /**
     * Creates a new instance.
     */
    public SnappyException()
    {
    }

    /**
     * Creates a new instance.
     */
    public SnappyException(String message, Throwable cause)
    {
        super(message, cause);
    }

    /**
     * Creates a new instance.
     */
    public SnappyException(String message)
    {
        super(message);
    }

    /**
     * Creates a new instance.
     */
    public SnappyException(Throwable cause)
    {
        super(cause);
    }
}
